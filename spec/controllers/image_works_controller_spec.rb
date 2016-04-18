require 'spec_helper'

describe CurationConcerns::ImageWorksController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  describe "#show_presenter" do
    it "is a image work show presenter" do
      expect(described_class.new.show_presenter).to eq(::GeoConcerns::ImageWorkShowPresenter)
    end
  end

  describe "#show" do
    before do
      sign_in user
    end
    context "with an existing image work" do
      it "is a success" do
        image = FactoryGirl.create(:image_work, user: user)

        get :show, id: image.id
        expect(response).to be_success
      end
    end
  end
end
