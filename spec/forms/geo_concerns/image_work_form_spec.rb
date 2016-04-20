require 'spec_helper'

describe GeoConcerns::ImageWorkForm do
  let(:coverage) { GeoConcerns::Coverage.new(43.039, -69.856, 42.943, -71.032) }
  let(:raw_attributes) { ActionController::Parameters.new(coverage: coverage.to_s) }

  describe ".model_attributes" do
    subject { described_class.model_attributes(raw_attributes) }
    it { is_expected.to eq('coverage' => coverage.to_s) }
  end
end
