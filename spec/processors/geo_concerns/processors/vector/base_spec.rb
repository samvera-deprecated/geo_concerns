require 'spec_helper'

describe GeoConcerns::Processors::Vector::Base do
  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files/geo.zip' }
  let(:label) {}
  let(:options) { { output_format: 'PNG', output_size: '150 150', label: label } }

  subject { described_class.new(file_name, {}) }

  describe '#encode' do
    context 'when output label is thumbnail' do
      let(:label) { :thumbnail }
      it 'calls the encode_vector method' do
        expect(subject.class).to receive(:encode_vector)
        subject.class.encode(file_name, options, output_file)
      end
    end

    context 'when output label is display_vector' do
      let(:label) { :display_vector }
      it 'calls the reproject_vector method' do
        expect(subject.class).to receive(:reproject_vector)
        subject.class.encode(file_name, options, output_file)
      end
    end
  end

  describe '#encode_vector' do
    it 'executes rasterize and translate commands, and cleans up files' do
      expect(subject.class).to receive(:execute).twice
      expect(File).to receive(:unlink)
      expect(File).to receive(:unlink).with("#{output_file}.aux.xml")
      subject.class.encode_vector(file_name, options, output_file)
    end
  end

  describe '#reproject_vector' do
    it 'executes the reproject command, zips the output, then cleans up' do
      expect(subject.class).to receive(:execute)
      expect(subject.class).to receive(:zip)
      expect(FileUtils).to receive(:rm_rf)
      subject.class.reproject_vector(file_name, options, output_file)
    end
  end

  describe '#rasterize' do
    it 'returns a gdal_rasterize command ' do
      expect(subject.class.rasterize(file_name, options, output_file))
        .to include('gdal_rasterize')
    end
  end

  describe '#reproject' do
    it 'returns a ogr2ogr command' do
      expect(subject.class.reproject(file_name, options, output_file))
        .to include('ogr2ogr', 'ESRI Shapefile')
    end
  end

  describe '#intermediate_shapefile_path' do
    it 'returns a path to a shapefile' do
      expect(subject.class.intermediate_shapefile_path('/test/path/file.zip'))
        .to eq('/test/path/file/')
    end
  end
end
