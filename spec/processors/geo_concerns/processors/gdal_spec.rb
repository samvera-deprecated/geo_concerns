require 'spec_helper'

describe GeoConcerns::Processors::BaseGeoProcessor do
  before do
    class TestProcessor
      include Hydra::Derivatives::Processors::ShellBasedProcessor
      include GeoConcerns::Processors::Gdal
      def directives
      end

      def source_path
      end
    end

    allow(subject).to receive(:directives).and_return(directives)
    allow(subject).to receive(:source_path).and_return(file_name)
  end

  after { Object.send(:remove_const, :TestProcessor) }

  subject { TestProcessor.new }

  let(:directives) { { format: 'png', size: '200x400' } }
  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files/geo.tif' }
  let(:options) { { output_size: '150 150', output_srid: 'EPSG:4326' } }

  describe '#translate' do
    it 'executes a gdal_translate command' do
      command = "gdal_translate -q -ot Byte -of GTiff \"files/geo.tif\" output/geo.png"
      expect(subject.class).to receive(:execute).with command
      subject.class.translate(file_name, output_file, options)
    end
  end

  describe '#warp' do
    it 'executes a reproject command' do
      command = "gdalwarp -q -r bilinear -t_srs EPSG:4326 files/geo.tif output/geo.png -co 'COMPRESS=NONE'"
      expect(subject.class).to receive(:execute).with command
      subject.class.warp(file_name, output_file, options)
    end
  end

  describe '#compress' do
    it 'returns a gdal_translate command with a compress option' do
      command = "gdal_translate -q -ot Byte -a_srs EPSG:4326 files/geo.tif output/geo.png -co 'COMPRESS=LZW'"
      expect(subject.class).to receive(:execute).with command
      subject.class.compress(file_name, output_file, options)
    end
  end

  describe '#rasterize' do
    it 'executes a rasterize command' do
      command = "gdal_rasterize -q -burn 0 -init 255 -ot Byte -ts 150 150 -of GTiff files/geo.tif output/geo.png"
      expect(subject.class).to receive(:execute).with command
      subject.class.rasterize(file_name, output_file, options)
    end
  end
end
