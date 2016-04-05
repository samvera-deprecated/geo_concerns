require 'rails_helper'

describe CurationConcerns::VectorWorksController do
  let(:user) { FactoryGirl.create(:user) }
  let(:vector_work) { FactoryGirl.create(:vector_work, user: user, title: ['Vector Work Title']) }
  let(:reloaded) { vector_work.reload }

  describe "#create" do
    let(:user) { FactoryGirl.create(:admin) }
    before do
      sign_in user
    end
    context "when given a parent" do
      let(:parent) { FactoryGirl.create(:raster_work, user: user) }
      let(:vector_work_attributes) do
        FactoryGirl.attributes_for(:vector_work)
      end
      it "creates and indexes its parent" do
        post :create, vector_work: vector_work_attributes, parent_id: parent.id
        solr_document = ActiveFedora::SolrService.query("id:#{assigns[:curation_concern].id}").first

        expect(solr_document["ordered_by_ssim"]).to eq [parent.id]
      end
    end
  end

  describe "#show" do
    before do
      sign_in user
    end
    context "when there's a parent raster work" do
      it "is a success" do
        vector = FactoryGirl.create(:vector_work, user: user)
        raster = FactoryGirl.create(:raster_work, user: user)
        raster.ordered_members << vector
        raster.save
        vector.update_index

        get :show, id: vector.id
        expect(response).to be_success
      end
    end
  end

  describe "#show_presenter" do
    it "is a vector work show presenter" do
      expect(CurationConcerns::VectorWorksController.new.show_presenter.name).to eq("VectorWorkShowPresenter")
    end
  end
end
