require 'spec_helper'

describe CurationConcerns::RastersController do
  it "has correct concern type" do
    expect(subject.curation_concern_type).to eq Raster
  end
end
