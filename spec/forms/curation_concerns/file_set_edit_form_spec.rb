require 'rails_helper'

describe CurationConcerns::FileSetEditForm do
  let(:raw_attributes) { ActionController::Parameters.new(conforms_to: 'FGDC') }

  describe ".model_attributes" do
    subject { described_class.model_attributes(raw_attributes) }
    it { is_expected.to eq('conforms_to' => 'FGDC') }
  end
end
