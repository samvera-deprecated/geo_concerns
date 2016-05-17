require 'spec_helper'
require 'open3'

describe GeoConcerns::Processors::Vector::Info do
  let(:path) { 'test.tif' }
  let(:info_doc) { read_test_data_fixture('ogrinfo.txt') }

  subject { described_class.new(path) }

  context 'when initializing a new info class' do
    it 'shells out to ogrinfo and sets the doc variable to the output string' do
      expect(Open3).to receive(:capture3).with("ogrinfo #{path}")
        .and_return([info_doc, '', ''])
      expect(subject.doc).to eq(info_doc)
    end
  end

  context 'after intialization' do
    before do
      allow(subject).to receive(:doc).and_return(info_doc)
    end

    describe '#name' do
      it 'returns with min and max values' do
        expect(subject.name).to eq('tufts-cambridgegrid100-04')
      end
    end

    describe '#driver' do
      it 'returns with min and max values' do
        expect(subject.driver).to eq('ESRI Shapefile')
      end
    end

    describe '#geom' do
      it 'returns raster size' do
        expect(subject.geom).to eq('Polygon')
      end
    end
  end
end
