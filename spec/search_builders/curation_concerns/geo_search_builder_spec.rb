require 'rails_helper'

describe CurationConcerns::GeoSearchBuilder do
  subject { described_class.new nil }
  it 'has a current_ability' do
    subject.current_ability = 'foo'
    expect(subject.current_ability).to eq 'foo'
  end
end
