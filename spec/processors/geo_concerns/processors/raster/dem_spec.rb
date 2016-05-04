require 'spec_helper'

describe GeoConcerns::Processors::Raster::Dem do
  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files/geo.dem' }
  let(:options) { { output_size: '150 150', label: :thumbnail }
  }

  subject { described_class.new(file_name, {}) }

  describe '#encode_queue' do
    it 'returns an array of command name symbols' do
      expect(subject.class.encode_queue).to include :hillshade
    end
  end

  describe '#reproject_queue' do
    it 'returns an array of command name symbols' do
      expect(subject.class.reproject_queue).to include :hillshade
    end
  end

  describe '#hillshade' do
    it 'executes a gdal hillshade command' do
      command = "gdaldem hillshade -q -of GTiff \"files/geo.dem\" output/geo.png"
      expect(subject.class).to receive(:execute).with command
      subject.class.hillshade(file_name, output_file, options)
    end
  end
end
