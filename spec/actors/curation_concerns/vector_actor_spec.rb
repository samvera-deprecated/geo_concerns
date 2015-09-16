require 'spec_helper'

describe CurationConcerns::VectorActor do
  it "class includes WorkActorBehavior" do
    expect(described_class.ancestors).to include(::CurationConcerns::WorkActorBehavior)
  end
end
