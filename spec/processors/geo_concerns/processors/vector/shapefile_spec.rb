require 'spec_helper'

describe GeoConcerns::Processors::Vector::Shapefile do
  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files/Shapefile.zip' }
  let(:options) { { output_format: 'PNG', output_size: '150 150', label: :thumbnail } }

  subject { described_class.new(file_name, {}) }

  describe '#encode' do
    it 'wraps encode vector method in an unzip block' do
      allow(subject.class).to receive(:unzip).and_yield(file_name)
      expect(subject.class).to receive(:encode_vector)
      subject.class.encode(file_name, options, output_file)
    end
  end
end
