require 'spec_helper'

describe GeoConcerns::Discovery::DocumentBuilder::BasicMetadataBuilder do
  subject { described_class.new(geo_concern) }

  let(:geo_concern) { FactoryGirl.build(:public_vector_work, id: 'geo-work-1') }
  let(:id_string) { 'ark:/99999/fk4' }

  describe '#identifier' do
    context 'nil' do
      it 'returns the geo_concern id' do
        allow(geo_concern).to receive(:identifier).and_return(nil)
        expect(subject.send(:identifier)).to eq 'geo-work-1'
      end
    end
    context 'String' do
      it 'returns the identifier string' do
        allow(geo_concern).to receive(:identifier).and_return(id_string)
        expect(subject.send(:identifier)).to eq id_string
      end
    end
    context 'empty array' do
      it 'returns the geo_concern id' do
        allow(geo_concern).to receive(:identifier).and_return([])
        expect(subject.send(:identifier)).to eq 'geo-work-1'
      end
    end
    context 'array with String' do
      it 'returns the identifier string' do
        allow(geo_concern).to receive(:identifier).and_return([id_string])
        expect(subject.send(:identifier)).to eq id_string
      end
    end
  end
end
