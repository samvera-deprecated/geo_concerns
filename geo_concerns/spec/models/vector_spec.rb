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
end
