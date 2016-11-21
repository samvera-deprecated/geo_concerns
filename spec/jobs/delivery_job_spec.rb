require 'spec_helper'
require 'uri'

describe GeoConcerns::DeliveryJob do
  let(:message) { { 'id' => 'abcdefg', 'event' => 'CREATED', "exchange" => :geoserver } }
  let(:content_url) { 'file:/somewhere-to-display-copy' }
  let(:file_format) { 'application/zip; ogr-format="ESRI Shapefile"' }
  let(:file_set) { instance_double(FileSet, derivative_url: content_url, geo_mime_type: file_format) }

  before do
    allow(ActiveFedora::Base).to receive(:find).and_return(file_set)
  end

  describe '#perform' do
    let(:service) { instance_double('GeoConcerns::DeliveryService') }
    context 'local vector file' do
      it 'delegates to DeliveryService' do
        expect(GeoConcerns::DeliveryService).to receive(:new).with(file_set, URI(content_url).path).and_return(service)
        expect(service).to receive(:publish)
        subject.perform(message)
      end
    end

    context 'local raster file' do
      let(:file_format) { 'image/tiff; gdal-format=GTiff' }
      it 'delegates to DeliveryService' do
        expect(GeoConcerns::DeliveryService).to receive(:new).with(file_set, URI(content_url).path).and_return(service)
        expect(service).to receive(:publish)
        subject.perform(message)
      end
    end

    context 'local image file' do
      let(:file_format) { 'image/jpeg' }
      it 'delegates to DeliveryService' do
        expect(GeoConcerns::DeliveryService).not_to receive(:new)
        subject.perform(message)
      end
    end

    context 'remote file' do
      let(:content_url) { 'http://somewhere/to-display-copy' }
      it 'errors out' do
        expect(GeoConcerns::DeliveryService).not_to receive(:new)
        expect { subject.perform(message) }.to raise_error(NotImplementedError, /Only supports file URLs/)
      end
    end
  end
end
