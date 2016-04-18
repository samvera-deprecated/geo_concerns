require 'spec_helper'

describe GeoConcerns::Processors::Raster::Dem do
  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files/geo.dem' }
  let(:options) { { output_format: 'PNG',
                    output_size: '150 150',
                    label: :thumbnail }
  }

  subject { described_class.new(file_name, {}) }

  describe '#translate' do
    it 'returns a translate command for the USGS Digital Elevation Model format' do
      expect(subject.class.translate(file_name, options, output_file))
        .to include('USGSDEM')
    end
  end

  describe '#hillshade' do
    it 'returns a gdal hillshade command' do
      expect(subject.class.hillshade(file_name, options, output_file))
        .to include('gdaldem hillshade')
    end
  end
end
