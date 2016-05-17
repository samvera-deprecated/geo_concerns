require 'spec_helper'

describe GeoConcerns::Processors::Vector::Base do
  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files/geo.zip' }
  let(:label) {}
  let(:options) { { output_size: '150 150', label: label } }

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

  describe '#encode_queue' do
    it 'returns an array of command name symbols' do
      expect(subject.class.encode_queue).to include :mapnik_vector_thumbnail
    end
  end

  describe '#reproject_queue' do
    it 'returns an array of command name symbols' do
      expect(subject.class.reproject_queue).to include :zip
    end
  end

  describe '#encode_vector' do
    it 'runs commands to encode the raster thumbnail' do
      expect(subject.class).to receive(:run_commands)
      subject.class.encode_vector(file_name, options, output_file)
    end
  end

  describe '#reproject_vector' do
    it 'runs commands to reproject the raster' do
      expect(subject.class).to receive(:run_commands)
      subject.class.reproject_vector(file_name, options, output_file)
    end
  end
end
