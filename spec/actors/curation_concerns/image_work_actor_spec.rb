# Generated via
#  `rails generate curation_concerns:work ImageWork`
require 'rails_helper'

describe CurationConcerns::ImageWorkActor do
  it 'behaves like a GenericWorkActor' do
    expect(described_class.included_modules).to include(::CurationConcerns::WorkActorBehavior)
  end
end
