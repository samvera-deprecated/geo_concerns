require 'spec_helper'

# This tests the Raster model. It includes the RasterBehavior module and nothing else.
# So this test covers both the RasterBehavior module and the Raster model
describe Raster do
  it "has a title" do
    subject.title = ['foo']
    expect(subject.title).to eq ['foo']
  end

  it "has a bbox" do
    subject.georss_box = '17.881242 -179.14734 71.390482 179.778465'
    expect(subject.georss_box).to eq '17.881242 -179.14734 71.390482 179.778465'
  end

  describe "to_solr" do
    subject { FactoryGirl.build(:raster, date_uploaded: Date.today).to_solr }
    it "indexes bbox field" do
      expect(subject.keys).to include 'georss_box_tesim'
    end
  end
end
