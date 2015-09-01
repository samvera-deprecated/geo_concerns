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

  it 'has attached content' do

    expect(subject.association(:original_file).to be_kind_of ActiveFedora::Associations::DirectlyContainsOneAssociation
  end

  describe "with a GeoTIFF" do

    before do

      Hydra::Works::AddFileToGenericFile.call(subject, File.open("#{fixture_path}/image0.tif", 'rb'), :original_file)
    end

    it 'is georeferenced to a bbox' do
    
      expect(subject.georss_box).to eq '-12.511 109.036 129.0530000 -5.0340000'
    end

    it 'has a CRS' do

      expect(subject.crs).to eq 'urn:ogc:def:crs:EPSG::6326'
    end
  end

  describe "to_solr" do
    subject { FactoryGirl.build(:raster, date_uploaded: Date.today).to_solr }
    it "indexes bbox field" do
      expect(subject.keys).to include 'georss_box_tesim'
    end
  end
end
