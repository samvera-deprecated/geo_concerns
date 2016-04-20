require 'spec_helper'

describe GeoConcerns::Processors::Raster::Aig do
  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files/aig.zip' }
  let(:options) { { output_format: 'PNG',
                    output_size: '150 150',
                    min_max: '2.054 11.717',
                    label: :thumbnail }
  }

  subject { described_class.new(file_name, {}) }

  describe '#translate' do
    it 'returns a gdal_translate command with scaling' do
      expect(subject.class.translate(file_name, options, output_file))
        .to include('-scale 2.054 11.717 255 0')
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
