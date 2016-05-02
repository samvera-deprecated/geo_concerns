require 'spec_helper'

describe GeoConcerns::RasterWorkForm do
  let(:coverage) { GeoConcerns::Coverage.new(43.039, -69.856, 42.943, -71.032) }
  let(:raw_attributes) { ActionController::Parameters.new(
    coverage: coverage.to_s,
    cartographic_projection: 'urn:ogc:def:crs:EPSG:6.3:26986')
  }

  describe '.model_attributes' do
    subject { described_class.model_attributes(raw_attributes) }
    it { is_expected.to include('coverage' => coverage.to_s) }
    it { is_expected.to include('cartographic_projection' => 'urn:ogc:def:crs:EPSG:6.3:26986') }
  end
end
