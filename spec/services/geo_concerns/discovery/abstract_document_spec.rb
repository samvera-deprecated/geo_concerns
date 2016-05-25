require 'spec_helper'

describe GeoConcerns::Discovery::AbstractDocument do
  subject { described_class.new }

  describe '#to_hash' do
    it 'raises an error because the class should not be instantiated directly' do
      expect { subject.to_hash(nil) }.to raise_error(/hash/)
    end
  end

  describe '#to_json' do
    it 'raises an error because the class should not be instantiated directly' do
      expect { subject.to_json(nil) }.to raise_error(/json/)
    end
  end

  describe '#to_xml' do
    it 'raises an error because the class should not be instantiated directly' do
      expect { subject.to_xml(nil) }.to raise_error(/xml/)
    end
  end
end
