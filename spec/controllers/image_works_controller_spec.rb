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

        get :show, params: { id: image.id }
        expect(response).to be_success
      end
    end
  end

  describe '#create' do
    let(:user) { FactoryGirl.create(:admin) }
    before do
      sign_in user
    end

    context 'when create is successful' do
      let(:work) { FactoryGirl.create(:image_work, user: user) }
      it 'creates an image work' do
        allow(controller).to receive(:curation_concern).and_return(work)
        post :create, params: { image_work: { title: ['a title'] } }
        expect(response).to redirect_to main_app.curation_concerns_image_work_path(work)
      end
    end
  end
end
