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
end
