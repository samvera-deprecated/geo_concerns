require 'spec_helper'

# This tests the Raster model. It includes the RasterBehavior module and nothing else.
# So this test covers both the RasterBehavior module and the Raster model
describe Raster do
  let(:user) { FactoryGirl.find_or_create(:jill) }

  it "has a title" do
    subject.title = ['foo']
    expect(subject.title).to eq ['foo']
  end

  it "has a bbox" do
    subject.georss_box = '17.881242 -179.14734 71.390482 179.778465'
    expect(subject.georss_box).to eq '17.881242 -179.14734 71.390482 179.778465'
  end

  context 'with raster files' do
    subject { FactoryGirl.create(:raster_with_files, title: ['Test title 4'], georss_box: '17.881242 -179.14734 71.390482 179.778465') }

    it 'has two files' do
      expect(subject.raster_files.size).to eq 2
      expect(subject.raster_files.first).to be_kind_of RasterFile
    end
  end

  context 'georeferenced from an image' do
    subject { FactoryGirl.create(:raster_with_images, title: ['Test title 4'], georss_box: '17.881242 -179.14734 71.390482 179.778465') }

    it 'is aggregated by an image resource' do
      expect(subject.images.size).to eq 1
      expect(subject.images.first).to be_kind_of Image

      expect(subject.image).to be_kind_of Image
    end
  end

  context 'with vector feature extractions' do
    subject { FactoryGirl.create(:raster_with_vectors) }

    it 'aggregates vector data set resources' do
      expect(subject.vectors.size).to eq 2
      expect(subject.vectors.first).to be_kind_of Vector
    end
  end

  context 'with metadata files' do
    subject { FactoryGirl.create(:raster_with_metadata_files) }

    it 'aggregates external metadata files' do
      expect(subject.metadata_files.size).to eq 2
      expect(subject.metadata_files.first).to be_kind_of RasterMetadataFile
    end
  end

  context 'when it is initialized' do
    it 'cannot have an empty arrays for all the properties' do

      # @todo Enforce cardinality constraints for cases in which instantiation should raise an exception
      
    end
  end  

  describe "to_solr" do
    subject { FactoryGirl.build(:raster, date_uploaded: Date.today).to_solr }
    it "indexes bbox field" do
      expect(subject.keys).to include 'georss_box_tesim'
    end
  end
end
