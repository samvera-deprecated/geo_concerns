require 'spec_helper'

describe GeoConcerns::Discovery::GeoblacklightDocument do
  subject { described_class.new }

  describe '#to_hash' do
    let(:document) { { id: 'test' } }

    before do
      allow(subject).to receive(:document).and_return(document)
    end

    it 'returns the document hash' do
      expect(subject.to_hash).to eq(document)
    end
  end
end
