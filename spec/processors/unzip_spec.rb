require 'spec_helper'

describe GeoConcerns::Processors::Unzip do
  before do
    class TestProcessor
      include Hydra::Derivatives::Processors::ShellBasedProcessor
      include GeoConcerns::Processors::Unzip
    end
  end

  after { Object.send(:remove_const, :TestProcessor) }

  subject { TestProcessor.new }

  describe '#unzip' do
    let(:path) { 'files/test.zip' }
    let(:output_file) { 'output/test.tif' }
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
end
