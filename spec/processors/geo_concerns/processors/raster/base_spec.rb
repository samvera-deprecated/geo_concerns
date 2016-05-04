require 'spec_helper'

describe GeoConcerns::Processors::Raster::Base do
  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files/geo.tif' }
  let(:label) {}
  let(:options) { { output_size: '150 150', label: label } }

  subject { described_class.new(file_name, {}) }

  describe '#encode' do
    context 'when output label is thumbnail' do
      let(:label) { :thumbnail }
      it 'calls the encode_raster method' do
        expect(subject.class).to receive(:encode_raster)
        subject.class.encode(file_name, options, output_file)
      end
    end

    context 'when output label is display_raster' do
      let(:label) { :display_raster }
      it 'calls the reproject_raster method' do
        expect(subject.class).to receive(:reproject_raster)
        subject.class.encode(file_name, options, output_file)
      end
    end
  end

  describe '#encode_queue' do
    it 'returns an array of command name symbols' do
      expect(subject.class.encode_queue).to include :translate
    end
  end

  describe '#reproject_queue' do
    it 'returns an array of command name symbols' do
      expect(subject.class.reproject_queue).to include :warp
    end
  end

  describe '#encode_raster' do
    it 'runs commands to encode the raster thumbnail' do
      expect(subject.class).to receive(:run_commands)
      subject.class.encode_raster(file_name, options, output_file)
    end
  end

  describe '#reproject_raster' do
    it 'runs commands to reproject the raster' do
      expect(subject.class).to receive(:run_commands)
      subject.class.reproject_raster(file_name, options, output_file)
    end
  end
end
