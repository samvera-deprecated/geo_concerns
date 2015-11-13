require 'rails_helper'

describe CurationConcerns::ImageWorkForm do
  let(:raw_attributes) { ActionController::Parameters.new(bounding_box: '42.943 -71.032 43.039 -69.856') }

  describe ".model_attributes" do
    subject { described_class.model_attributes(raw_attributes) }
    it { is_expected.to eq('bounding_box' => '42.943 -71.032 43.039 -69.856') }
  end
end
