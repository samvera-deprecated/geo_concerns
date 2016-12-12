require 'spec_helper'

describe CurationConcerns::ImageWorksController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:image_work) { FactoryGirl.create(:image_work, user: user, title: ['Image Work Title']) }
  let!(:sipity_entity) do
    create(:sipity_entity, proxy_for_global_id: image_work.to_global_id.to_s)
  end

  describe "#show_presenter" do
    it "is a image work show presenter" do
      expect(described_class.new.show_presenter).to eq(::GeoConcerns::ImageWorkShowPresenter)
    end
  end

  describe '#form_class' do
    it 'returns the raster work form class' do
      expect(described_class.new.form_class). to eq(CurationConcerns::ImageWorkForm)
    end
  end

  describe "#show" do
    before do
      sign_in user
    end
    context "with an existing image work" do
      it "is a success" do
        get :show, params: { id: image_work.id }
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
