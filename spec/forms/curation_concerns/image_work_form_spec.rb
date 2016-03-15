require 'rails_helper'

describe CurationConcerns::ImageWorkForm do
  let(:raw_attributes) { ActionController::Parameters.new(coverage: 'northlimit=43.039; eastlimit=-69.856; southlimit=42.943; westlimit=-71.032; units=degrees; projection=EPSG:4326') }

  describe ".model_attributes" do
    subject { described_class.model_attributes(raw_attributes) }
    it { is_expected.to eq('coverage' => 'northlimit=43.039; eastlimit=-69.856; southlimit=42.943; westlimit=-71.032; units=degrees; projection=EPSG:4326') }
  end
end
