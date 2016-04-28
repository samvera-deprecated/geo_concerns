require 'spec_helper'
require 'open3'

describe GeoConcerns::Processors::Raster::Info do
  let(:path) { 'test.tif' }
  let(:info_doc) { read_test_data_fixture('gdalinfo.txt') }

  subject { described_class.new(path) }

  context 'when initializing a new info class' do
    it 'shells out to gdalinfo and sets the doc variable to the output string' do
      expect(Open3).to receive(:capture3).with("gdalinfo -mm #{path}")
        .and_return([info_doc, '', ''])
      expect(subject.doc).to eq(info_doc)
    end
  end

  context 'after intialization' do
    before do
      allow(subject).to receive(:doc).and_return(info_doc)
    end

    describe '#min_max' do
      it 'returns with min and max values' do
        expect(subject.min_max).to eq('354.000 900.000')
      end
    end

    describe '#width' do
      it 'returns raster width' do
        expect(subject.width).to eq(310)
      end
    end

    describe '#height' do
      it 'returns raster height' do
        expect(subject.height).to eq(266)
      end
    end
  end
end
