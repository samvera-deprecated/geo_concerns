require 'spec_helper'

describe GeoConcerns::Processors::BaseGeoProcessor do
  before do
    class TestProcessor
      include GeoConcerns::Processors::BaseGeoProcessor
    end

    allow(subject).to receive(:directives).and_return(directives)
  end

  after { Object.send(:remove_const, :TestProcessor) }

  subject { TestProcessor.new }

  let(:directives) { { format: 'png', size: '200x400' } }
  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files/geo.tif' }
  let(:options) { { output_format: 'PNG', output_size: '150 150' } }

  describe '#translate' do
    it 'returns a gdal_translate command ' do
      expect(subject.class.translate(file_name, options, output_file))
        .to include('gdal_translate')
    end
  end

  describe '#rasterize' do
    it 'returns a gdal_rasterize command' do
      expect(subject.class.rasterize(file_name, options, output_file))
        .to include('gdal_rasterize')
    end
  end

  describe '#output_format' do
    context 'when given jpg as a format' do
      let(:directives) { { format: 'jpg' } }
      it 'returns JPEG' do
        expect(subject.output_format).to eq('JPEG')
      end
    end

    context 'when given png as a format' do
      it 'returns PNG' do
        expect(subject.output_format).to eq('PNG')
      end
    end
  end

  describe '#output_size' do
    context 'when given a size string with an x' do
      it 'returns a size string with a space instead' do
        expect(subject.output_size).to eq('200 400')
      end
    end
  end

  describe '#options_for' do
    it 'returns a hash that includes output size and format' do
      expect(subject.options_for("a")).to include(:output_format, :output_size)
    end
  end
end
