require 'spec_helper'

describe GeoConcerns::Processors::Mapnik do
  before do
    class TestProcessor
      include GeoConcerns::Processors::Mapnik
    end
  end

  after { Object.send(:remove_const, :TestProcessor) }

  subject { TestProcessor.new }

  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files' }
  let(:options) { { output_size: '150 150' } }

  describe '#mapnik_vector_thumbnail' do
    let(:map) { double }
    let(:info) { double }

    before do
      allow(GeoConcerns::Processors::Vector::Info).to receive(:new).and_return(info)
      allow(SimpleMapnik::Map).to receive(:new).and_return(map)
    end

    it 'saves a vector thumbnail using simple_mapnik' do
      expect(info).to receive(:name).and_return('test')
      expect(map).to receive(:load_string)
      expect(map).to receive(:zoom_all)
      expect(map).to receive(:to_file).with(output_file)
      subject.class.mapnik_vector_thumbnail(file_name, output_file, options)
    end

    describe '#mapnik_size' do
      it 'returns an array of width and height' do
        expect(subject.class.mapnik_size(options)).to eq([150, 150])
      end
    end

    describe '#mapnik_config' do
      it 'returns a mapnik config object' do
        options[:name] = 'test'
        expect(subject.class.mapnik_config(file_name, options)).to be_a(SimpleMapnik::Config)
      end
    end
  end
end
