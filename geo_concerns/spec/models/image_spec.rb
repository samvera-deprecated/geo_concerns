require 'spec_helper'

# This tests the Image model. It includes the ImageBehavior module and nothing else.
# So this test covers both the ImageBehavior module and the generated Image model
describe Image do
  let(:user) { FactoryGirl.find_or_create(:jill) }

  it "has a title" do
    subject.title = ['foo']
    expect(subject.title).to eq ['foo']
  end

  it "has a bbox" do
    subject.georss_box = '17.881242 -179.14734 71.390482 179.778465'
    expect(subject.georss_box).to eq '17.881242 -179.14734 71.390482 179.778465'
  end

  it 'has a width' do
    
    subject.width = [380]
    expect(subject.width).to eq([380])
  end

  it 'has a height' do
        
    subject.height = [765]
    expect(subject.height).to eq([765])
  end

  context 'with an image file' do
    subject { FactoryGirl.create(:image_with_one_file, title: ['Test title 3']) }

    it 'has an image file' do
      expect(subject.image_file).to be_kind_of ImageFile
    end
  end

  context 'with georectified rasters' do
    subject { FactoryGirl.create(:image_with_rasters, title: ['Test title 4']) }

    it 'has two rasters' do
      expect(subject.rasters.size).to eq 2
      expect(subject.rasters.first).to be_kind_of Raster
    end

    describe "containing a GeoTIFF" do

      before do

        # Please see the comments above
        nil
      end

    end
  end
end
