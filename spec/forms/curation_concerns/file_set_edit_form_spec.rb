require 'rails_helper'

describe CurationConcerns::FileSetEditForm do
  let(:raw_attributes) { ActionController::Parameters.new(geo_file_format: 'SHAPEFILE') }

  describe ".model_attributes" do
    subject { described_class.model_attributes(raw_attributes) }
    it { is_expected.to eq('geo_file_format' => 'SHAPEFILE') }
  end
end
