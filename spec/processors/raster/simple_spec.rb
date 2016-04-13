require 'spec_helper'

describe GeoConcerns::Processors::Raster::Simple do
  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files/geo.tif' }
  let(:options) { { output_format: 'PNG', output_size: '150 150' } }

  subject { described_class.new(file_name, {}) }

  describe '#encode' do
    it "executes the translate command and cleans up aux file" do
      expect(subject.class).to receive(:execute)
      expect(File).to receive(:unlink).with("#{output_file}.aux.xml")
      subject.class.encode(file_name, options, output_file)
    end
  end
end
