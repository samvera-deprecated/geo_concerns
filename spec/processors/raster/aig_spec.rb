require 'spec_helper'

describe GeoConcerns::Processors::Raster::Aig do
  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files/geo.tif' }
  let(:options) { { output_format: 'PNG', output_size: '150 150', min_max: '2.054 11.717' } }

  subject { described_class.new(file_name, {}) }

  describe '#translate' do
    it 'returns a gdal_translate command with scaling' do
      expect(subject.class.translate(file_name, options, output_file))
        .to include('-scale 2.054 11.717 255 0')
    end
  end

  describe '#get_raster_min_max' do
    let(:min_max) { subject.class.get_raster_min_max(info_string) }

    context 'when a string has computed min and max' do
      let(:info_string) { 'Band 1 Block=256x16 Type=Float32 Computed Min/Max=2.054,11.717 ' }

      it 'returns with formatted text' do
        expect(min_max).to eq('2.054 11.717')
      end
    end

    context 'when a string does not have a computed min and max' do
      let(:info_string) { 'Band 1 Block=256x16 Type=Float32' }

      it 'returns with formatted text' do
        expect(min_max).to eq('')
      end
    end
  end

  describe '#gdalinfo' do
    it 'shells out to gdalinfo and returns the output as a string' do
      expect(Open3).to receive(:capture3).with("gdalinfo -mm #{file_name}")
        .and_return(['info', '', ''])
      expect(subject.class.gdalinfo(file_name)).to eq('info')
    end
  end

  describe '#encode' do
    it 'wraps encode_raster in an unzip block' do
      allow(subject.class).to receive(:unzip).and_yield(file_name)
      expect(subject.class).to receive(:encode_raster)
      subject.class.encode(file_name, options, output_file)
    end
  end
end
