require 'spec_helper'

describe CurationConcerns::RasterActor do
  it "class includes WorkActorBehavior" do
    expect(described_class.ancestors).to include(::CurationConcerns::WorkActorBehavior)
  end
end
