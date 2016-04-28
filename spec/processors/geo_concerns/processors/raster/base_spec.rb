require 'spec_helper'

describe GeoConcerns::Processors::Raster::Base do
  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files/geo.tif' }
  let(:label) {}
  let(:options) { { output_format: 'PNG', output_size: '150 150', label: label } }

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

  describe '#encode_raster' do
    it 'executes the translate command and cleans up aux file' do
      expect(subject.class).to receive(:execute)
      expect(File).to receive(:unlink).with("#{output_file}.aux.xml")
      subject.class.encode_raster(file_name, options, output_file)
    end
  end

  describe '#reproject_raster' do
    it 'executes the warp and compress commands, then cleans up intermediate file' do
      expect(subject.class).to receive(:execute).twice
      expect(FileUtils).to receive(:rm_rf)
      subject.class.reproject_raster(file_name, options, output_file)
    end
  end

  describe '#warp' do
    it 'returns a gdalwarp command ' do
      expect(subject.class.warp(file_name, options, output_file))
        .to include('gdalwarp')
    end
  end

  describe '#compress' do
    it 'returns a gdal_translate command with a compress option' do
      expect(subject.class.compress(file_name, options, output_file))
        .to include('gdal_translate', 'COMPRESS=LZW')
    end
  end
end
