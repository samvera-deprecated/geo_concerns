require 'rails_helper'

describe CurationConcerns::VectorWorkForm do
  let(:raw_attributes) { ActionController::Parameters.new(
    coverage: 'northlimit=43.039; eastlimit=-69.856; southlimit=42.943; westlimit=-71.032; units=degrees; projection=EPSG:4326',
    cartographic_projection: 'urn:ogc:def:crs:EPSG:6.3:26986') }

  describe '.model_attributes' do
    subject { described_class.model_attributes(raw_attributes) }
    it { is_expected.to include('coverage' => 'northlimit=43.039; eastlimit=-69.856; southlimit=42.943; westlimit=-71.032; units=degrees; projection=EPSG:4326') }
    it { is_expected.to include('cartographic_projection' => 'urn:ogc:def:crs:EPSG:6.3:26986') }
  end
end
