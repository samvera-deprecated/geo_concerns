require 'spec_helper'

# This tests the Vector model. It includes the VectorBehavior module and nothing else.
# So this test covers both the VectorBehavior module and the Vector model
describe Vector do
  it "has a title" do
    subject.title = ['foo']
    expect(subject.title).to eq ['foo']
  end

  it "has a bbox" do
    subject.georss_box = '17.881242 -179.14734 71.390482 179.778465'
    expect(subject.georss_box).to eq '17.881242 -179.14734 71.390482 179.778465'
  end

  context 'with files' do
    subject { FactoryGirl.create(:vector_with_files, title: ['Test title 4'], georss_box: '17.881242 -179.14734 71.390482 179.778465') }

    it 'has two files' do
      expect(subject.vector_files.size).to eq 2
      expect(subject.vector_files.first).to be_kind_of VectorFile
    end
  end

  context 'extracting features from rasters' do
    subject { FactoryGirl.create(:vector_with_rasters) }

    it 'aggregates two resources' do
      expect(subject.rasters.size).to eq 2
      expect(subject.rasters.first).to be_kind_of Raster
    end
  end
end
