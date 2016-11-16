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

      it 'logs a message if there is an error' do
        expect(subject).to receive(:publish_vector).and_raise(StandardError, 'error')
        expect(Rails.logger).to receive(:error).with("GeoServer delivery job failed with: error")
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
        expect(Rails.logger).to receive(:error).with(/Not a ZIPed Shapefile/)
        subject.publish
      end
    end
  end

  describe '#publish_vector' do
    context 'with a path to a zipped shapefile' do
      let(:shapefile_path) { ['/spec/fixtures/files/shapefile/tufts-cambridgegrid100-04/tufts-cambridgegrid100-04.shp'] }
      let(:url) { "file:////opt/geoserver/data_dir/derivatives#{shapefile_path.first}" }
      let(:ws) { double }
      let(:ds) { double }

      before do
        allow(Dir).to receive(:glob).and_return(shapefile_path)
      end

      it 'dispatches to RGeoServer' do
        expect(RGeoServer::Workspace).to receive(:new).with(subject.catalog, hash_including(name: 'public')).and_return(ws)
        expect(ws).to receive(:'new?').and_return(true)
        expect(ws).to receive(:save)
        expect(RGeoServer::DataStore).to receive(:new).with(subject.catalog, hash_including(workspace: ws, name: id)).and_return(ds)
        expect(ds).to receive(:upload_external).with(url, hash_including(publish: true))
        subject.send(:publish_vector)
      end
    end
  end

  describe '#publish_raster' do
    let(:path) { 'spec/fixtures/files/S_566_1914_clip.tif' }
    let(:url) { 'file:////opt/geoserver/data_dir/derivativesspec/fixtures/files/S_566_1914_clip.tif' }
    let(:ws) { double }
    let(:cs) { double }
    let(:cov) { double }

    it 'dispatches to RGeoServer' do
      expect(RGeoServer::Workspace).to receive(:new).with(subject.catalog, hash_including(name: 'public')).and_return(ws).twice
      expect(ws).to receive(:'new?').and_return(true).twice
      expect(ws).to receive(:save).twice
      expect(RGeoServer::CoverageStore).to receive(:new).with(subject.catalog, hash_including(workspace: ws, name: id)).and_return(cs)
      expect(cs).to receive(:name).and_return('abcdefg').at_least(:once)
      expect(cs).to receive(:url=).with(url)
      expect(cs).to receive(:enabled=).with('true')
      expect(cs).to receive(:data_type=).with('GeoTIFF')
      expect(cs).to receive(:save)
      expect(RGeoServer::Coverage).to receive(:new).with(subject.catalog, hash_including(workspace: ws, coverage_store: cs, name: cs.name)).and_return(cov)
      expect(cov).to receive(:title=).with(cs.name)
      expect(cov).to receive(:metadata_links=).with([])
      expect(cov).to receive(:save)
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
