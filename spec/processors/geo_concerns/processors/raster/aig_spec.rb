require 'spec_helper'

describe GeoConcerns::Processors::Raster::Aig do
  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files/aig.zip' }
  let(:options) { { output_size: '150 150',
                    min_max: '2.054 11.717',
                    label: :thumbnail }
  }

  subject { described_class.new(file_name, {}) }

  describe '#translate' do
    it 'executes a gdal_translate command with scaling' do
      command = "gdal_translate -scale 2.054 11.717 255 0 -q -ot Byte -of "\
                  "GTiff \"files/aig.zip\" output/geo.png"
      expect(subject.class).to receive(:execute).with command
      subject.class.translate(file_name, output_file, options)
    end
  end

  describe '#reproject_queue' do
    it 'returns an array of command name symbols' do
      expect(subject.class.reproject_queue).to include :warp
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
