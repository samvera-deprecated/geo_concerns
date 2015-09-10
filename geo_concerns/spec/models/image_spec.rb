require 'spec_helper'

# This tests the Image model. It includes the ImageBehavior module and nothing else.
# So this test covers both the ImageBehavior module and the generated Image model
describe Image do
  it "has a title" do
    subject.title = ['foo']
    expect(subject.title).to eq ['foo']
  end

  it "has a bbox" do
    subject.georss_box = '17.881242 -179.14734 71.390482 179.778465'
    expect(subject.georss_box).to eq '17.881242 -179.14734 71.390482 179.778465'
  end

  describe 'with a Raster' do

    it 'has related content' do

      # jrgriffinii: I'm uncertain as to how this shall be related using the CurationConcerns behavior
      # Perhaps by means of validating the relationship with Raster resources?
      nil
    end

    describe "containing a GeoTIFF" do

      before do

        # Please see the comments above
        nil
      end

      it 'has a width' do
    
        subject.width = [380]
        expect(subject.width).to eq([380])
      end

      it 'has a height' do
        
        subject.height = [765]
        expect(subject.height).to eq([765])
      end
    end
  end
end
