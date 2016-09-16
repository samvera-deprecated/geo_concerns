require 'spec_helper'

describe GeoConcerns::Delivery::Geoserver do
  let(:id) { 'abc123' }
  let(:file_set) { instance_double("FileSet") }
  let(:visibility) { 'open' }
  let(:path) { 'spec/fixtures/files/tufts-cambridgegrid100-04.zip' }

  subject { described_class.new file_set, path }

  before do
    allow(file_set).to receive(:visibility).and_return(visibility)
    allow(file_set).to receive(:id).and_return(id)
  end

  context 'with an authenticated file set visibility' do
    let(:visibility) { 'authenticated' }
    it 'does not raise error' do
      expect { subject }.not_to raise_error
    end
  end

  context 'with a private file set visibility' do
    let(:visibility) { 'private' }
    it 'raises an error' do
      expect { subject }.to raise_error(ArgumentError, /FileSet visibility/)
    end
  end

  describe '#publish' do
    context 'when type is vector' do
      let(:path) { 'spec/fixtures/files/tufts-cambridgegrid100-04.zip' }
      it 'routes to publish_vector' do
        expect(subject).to receive(:publish_vector)
        subject.publish
      end
    end

    context 'when type is raster' do
      let(:path) { 'spec/fixtures/files/S_566_1914_clip.tif' }
      it 'routes to publish_raster' do
        expect(subject).to receive(:publish_raster)
        subject.publish
      end
    end

    context 'when type is not a raster or vector' do
      let(:path) { 'not-a-zip-or-tif' }
      it 'raises an error' do
        expect { subject.publish }.to raise_error(ArgumentError, /Not a ZIPed Shapefile/)
      end
    end
  end

  describe '#publish_vector' do
    context 'with a path to a zipped shapefile' do
      let(:ws) { double }
      let(:ds) { double }

      it 'dispatches to RGeoServer' do
        expect(RGeoServer::Workspace).to receive(:new).with(subject.catalog, hash_including(name: 'public')).and_return(ws)
        expect(ws).to receive(:'new?').and_return(true)
        expect(ws).to receive(:save)
        expect(RGeoServer::DataStore).to receive(:new).with(subject.catalog, hash_including(workspace: ws, name: id)).and_return(ds)
        expect(ds).to receive(:upload_file).with(path, hash_including(publish: true))
        subject.send(:publish_vector)
      end
    end
  end

  describe '#publish_raster' do
    let(:path) { 'spec/fixtures/files/S_566_1914_clip.tif' }
    let(:ws) { double }
    let(:cs) { double }

    it 'dispatches to RGeoServer' do
      expect(RGeoServer::Workspace).to receive(:new).with(subject.catalog, hash_including(name: 'public')).and_return(ws)
      expect(ws).to receive(:'new?').and_return(true)
      expect(ws).to receive(:save)
      expect(RGeoServer::CoverageStore).to receive(:new).with(subject.catalog, hash_including(workspace: ws, name: id)).and_return(cs)
      expect(cs).to receive(:upload).with(path)
      subject.send(:publish_raster)
    end
  end

  describe '#catalog' do
    it 'connects to a RGeoServer catalog' do
      expect(RGeoServer).to receive(:catalog).with(hash_including(:url, :user, :password)).and_return(double).once
      subject.catalog
      subject.catalog # should cache result
    end
  end
end
