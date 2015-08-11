require 'spec_helper'

describe GeoHydra::Works do
  it 'should be a module' do
    expect(subject.is_a? Module).to be_truthy
  end
end