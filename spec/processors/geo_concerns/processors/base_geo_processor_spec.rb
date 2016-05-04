require 'spec_helper'

describe GeoConcerns::Processors::BaseGeoProcessor do
  before do
    class TestProcessor
      include GeoConcerns::Processors::BaseGeoProcessor
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
  let(:options) { { output_size: '150 150' } }

  describe '#run_commands' do
    let(:method_queue) { [:translate, :warp, :compress] }
    it 'calls the methods in the queue and cleans up temp files' do
      expect(subject.class).to receive(:translate)
      expect(subject.class).to receive(:warp)
      expect(subject.class).to receive(:compress)
      expect(FileUtils).to receive(:rm_rf).twice
      subject.class.run_commands(file_name, output_file, method_queue, options)
    end
  end

  describe '#convert' do
    let(:image) { double }

    before do
      allow(MiniMagick::Image).to receive(:open).and_return(image)
    end

    it 'transforms the image and saves it as a jpeg' do
      expect(image).to receive(:format).with('jpg')
      expect(image).to receive(:combine_options)
      expect(image).to receive(:write).with(output_file)
      subject.class.convert(file_name, output_file, options)
    end
  end

  describe '#temp_path' do
    it 'returns a path to a temporary file based on the input file' do
      expect(subject.class.temp_path(output_file))
        .to include('geo')
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
      expect(subject.options_for("a")).to include(:output_size,
                                                  :label,
                                                  :output_srid,
                                                  :basename)
    end
  end
end
