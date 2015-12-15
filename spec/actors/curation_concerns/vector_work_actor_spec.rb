# Generated via
#  `rails generate curation_concerns:work Vector`
require 'rails_helper'

describe CurationConcerns::VectorWorkActor do
  it 'behaves like a GenericWorkActor' do
    expect(described_class.included_modules).to include(::CurationConcerns::WorkActorBehavior)
  end
end
