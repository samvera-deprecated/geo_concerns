require 'rails_helper'

describe CurationConcerns::RasterWorkForm do
  let(:raw_attributes) { ActionController::Parameters.new(
    bounding_box: '42.943 -71.032 43.039 -69.856',
    cartographic_projection: 'urn:ogc:def:crs:EPSG:6.3:26986') }

  describe '.model_attributes' do
    subject { described_class.model_attributes(raw_attributes) }
    it { is_expected.to include('bounding_box' => '42.943 -71.032 43.039 -69.856') }
    it { is_expected.to include('cartographic_projection' => 'urn:ogc:def:crs:EPSG:6.3:26986') }
  end
end
