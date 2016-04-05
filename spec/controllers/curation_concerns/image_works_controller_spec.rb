require 'rails_helper'

describe CurationConcerns::ImageWorksController do
  let(:user) { FactoryGirl.create(:user) }

  describe "#show_presenter" do
    it "is a image work show presenter" do
      expect(CurationConcerns::ImageWorksController.new.show_presenter).to eq(ImageWorkShowPresenter)
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
