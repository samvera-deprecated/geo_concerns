require 'spec_helper'

describe GeoConcerns::Processors::Zip do
  before do
    class TestProcessor
      include Hydra::Derivatives::Processors::ShellBasedProcessor
      include GeoConcerns::Processors::Zip
    end
  end

  after { Object.send(:remove_const, :TestProcessor) }

  subject { TestProcessor.new }
  let(:path) { 'files/test.zip' }
  let(:output_file) { 'output/test.tif' }

  describe '#unzip' do
    let(:command) { 'unzip -qq -j -d "output/test_out" "files/test.zip"' }

    context 'given an input and output path' do
      it 'runs an unzip command and yields to a block' do
        arg = ''
        expect(subject.class).to receive(:execute).with(command)
        expect(FileUtils).to receive(:rm_rf)
        subject.class.unzip(path, output_file) { |a| arg = a }
        expect(arg).to eq('output/test_out')
      end
    end
  end

  describe '#zip' do
    let(:command) { 'zip -j -qq -r "output/test.tif" "files/test.zip"' }

    it 'runs a zip command ' do
      expect(subject.class).to receive(:execute).with(command)
      subject.class.zip(path, output_file)
    end
  end
end
