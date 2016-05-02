require 'spec_helper'

describe GeoConcerns::Processors::Raster::Processor do
  subject { described_class.new(file_name, directives) }
  let(:processor) { double }

  context 'when a usgs ascii dem format type is passed' do
    let(:file_name) { 'files/geo.dem' }
    let(:directives) { { input_format: 'text/plain; gdal-format=USGSDEM' } }

    it 'calls the DEM processor' do
      expect(GeoConcerns::Processors::Raster::Dem).to receive(:new).and_return(processor)
      expect(processor).to receive(:process)
      subject.process
    end
  end

  context 'when an Arc/Info Binary Grid format type is passed' do
    let(:file_name) { 'files/aig.zip' }
    let(:directives) { { input_format: 'application/octet-stream; gdal-format=AIG' } }

    it 'calls the AIG processor' do
      expect(GeoConcerns::Processors::Raster::Aig).to receive(:new).and_return(processor)
      expect(processor).to receive(:process)
      subject.process
    end
  end

  context 'when a GeoTIFF format type is passed' do
    let(:file_name) { 'files/geo.tif' }
    let(:directives) { { input_format: 'image/tiff; gdal-format=GTiff' } }

    it 'calls the base raster processor' do
      expect(GeoConcerns::Processors::Raster::Base).to receive(:new).and_return(processor)
      expect(processor).to receive(:process)
      subject.process
    end
  end
end
