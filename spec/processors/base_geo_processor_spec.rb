require 'spec_helper'

describe GeoConcerns::Processors::BaseGeoProcessor do
  before do
    class TestProcessor
      include GeoConcerns::Processors::BaseGeoProcessor
    end

    allow(subject).to receive(:directives).and_return(directives)
    allow(subject).to receive(:source_path).and_return(file_name)
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

  describe '#intermediate_file_path' do
    it 'returns a path to a temporary file based on the input file' do
      expect(subject.class.intermediate_file_path(output_file))
        .to include('geo_temp.png')
    end
  end

  describe '#label' do
    context 'when directives hash has a label value' do
      let(:directives) { { label: :thumbnail } }
      it 'returns the label' do
        expect(subject.label).to eq(:thumbnail)
      end
    end

    context 'when directives hash does not have label value' do
      it 'returns an empty string' do
        expect(subject.label).to eq('')
      end
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

  describe '#output_srid' do
    context 'when directives hash has an srid value' do
      let(:directives) { { srid: 'EPSG:26918' } }
      it 'returns that value' do
        expect(subject.output_srid).to eq('EPSG:26918')
      end
    end

    context 'when directives hash does not have an srid value' do
      it 'returns that the default srid' do
        expect(subject.output_srid).to eq('EPSG:4326')
      end
    end
  end

  describe '#basename' do
    it 'returns the base file name of the source file' do
      expect(subject.basename).to eq('geo')
    end
  end

  describe '#options_for' do
    it 'returns a hash that includes output size and format' do
      expect(subject.options_for("a")).to include(:output_format,
                                                  :output_size,
                                                  :label,
                                                  :output_srid,
                                                  :basename)
    end
  end
end
