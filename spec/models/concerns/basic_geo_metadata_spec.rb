require 'spec_helper'

RSpec.describe GeoConcerns::BasicGeoMetadata do
  subject { VectorWork.new }

  it 'inherits the specified properties' do
    %w(title date_uploaded date_modified contributor creator date_created
       description identifier language part_of publisher resource_type
       rights source subject keyword).map(&:to_sym).each do |p|
      expect(subject.respond_to?(p)).to be_truthy
      expect(subject.respond_to?("#{p}=".to_sym)).to be_truthy
    end
  end

  it 'defines the specified properties' do
    %w(coverage provenance spatial temporal issued).map(&:to_sym).each do |p|
      expect(subject.respond_to?(p)).to be_truthy
      expect(subject.respond_to?("#{p}=".to_sym)).to be_truthy
    end
  end
end
