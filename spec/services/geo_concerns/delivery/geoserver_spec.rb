require 'spec_helper'

describe GeoConcerns::Delivery::Geoserver do
  let(:id) { 'abc123' }

  context '#initialize' do
    it 'configures correctly with defaults' do
      expect(File).to receive(:read).and_raise(Errno::ENOENT)
      expect { subject }.not_to raise_error
      expect(subject.config).to include('url' => 'http://localhost:8181/geoserver/rest',
                                        'user' => 'admin',
                                        'password' => 'geoserver')
    end
  end

  context '#catalog' do
    it 'connects to a RGeoServer catalog' do
      expect(RGeoServer).to receive(:catalog).with(hash_including(:url, :user, :password)).and_return(double).once
      subject.catalog
      subject.catalog # should cache result
    end
  end

  context '#publish' do
    it 'requires a valid type' do
      expect { subject.publish(id, 'some/file', :unknown) }.to raise_error(ArgumentError, /Unknown file type/)
    end
    context 'vector' do
      let(:type) { :vector }
      let(:filename) { 'file.zip' }
      it 'routes to publish_vector' do
        expect(subject).to receive(:publish_vector).with(id, filename)
        subject.publish(id, filename, type)
      end
    end
    context 'raster' do
      let(:type) { :raster }
      let(:filename) { 'file.tif' }
      it 'routes to publish_raster' do
        expect(subject).to receive(:publish_raster).with(id, filename)
        subject.publish(id, filename, type)
      end
    end
  end

  context '#publish_vector' do
    let(:filename) { 'spec/fixtures/files/tufts-cambridgegrid100-04.zip' }
    it 'requires a vector ZIP file' do
      expect { subject.send(:publish_vector, id, 'not-a-zip') }.to raise_error(ArgumentError, /Not ZIPed Shapefile/)
    end
    it 'dispatches to RGeoServer' do
      ws_dbl = double
      expect(RGeoServer::Workspace).to receive(:new).with(subject.catalog, hash_including(name: 'geo')).and_return(ws_dbl)
      expect(ws_dbl).to receive(:'new?').and_return(true)
      expect(ws_dbl).to receive(:save)
      ds_dbl = double
      expect(RGeoServer::DataStore).to receive(:new).with(subject.catalog, hash_including(workspace: ws_dbl, name: id)).and_return(ds_dbl)
      expect(ds_dbl).to receive(:upload_file).with(filename, hash_including(publish: true))
      subject.send(:publish_vector, id, filename)
    end
  end

  context '#publish_raster' do
    let(:filename) { 'spec/fixtures/files/S_566_1914_clip.tif' }
    it 'requires GeoTIFF' do
      expect { subject.send(:publish_raster, id, 'not-a-tiff') }.to raise_error(ArgumentError, /Not GeoTIFF/)
    end
    it 'is not implemented yet' do
      expect { subject.send(:publish_raster, id, filename) }.to raise_error(NotImplementedError)
    end
  end
end
