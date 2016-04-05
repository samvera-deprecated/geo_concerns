require 'rails_helper'

describe CurationConcerns::RasterWorksController do
  let(:user) { FactoryGirl.create(:user) }
  let(:raster_work) { FactoryGirl.create(:raster_work, user: user, title: ['Raster Work Title']) }
  let(:reloaded) { raster_work.reload }

  describe "#create" do
    let(:user) { FactoryGirl.create(:admin) }
    before do
      sign_in user
    end
    context "when given a parent" do
      let(:parent) { FactoryGirl.create(:image_work, user: user) }
      let(:raster_work_attributes) do
        FactoryGirl.attributes_for(:raster_work)
      end
      it "creates and indexes its parent" do
        post :create, raster_work: raster_work_attributes, parent_id: parent.id
        solr_document = ActiveFedora::SolrService.query("id:#{assigns[:curation_concern].id}").first

        expect(solr_document["ordered_by_ssim"]).to eq [parent.id]
      end
    end
  end

  describe "#show" do
    before do
      sign_in user
    end
    context "when there's a parent image work" do
      it "is a success" do
        raster = FactoryGirl.create(:raster_work, user: user)
        image = FactoryGirl.create(:image_work, user: user)
        image.ordered_members << raster
        image.save
        raster.update_index

        get :show, id: raster.id
        expect(response).to be_success
      end
    end
  end

  describe "#show_presenter" do
    it "is a raster work show presenter" do
      expect(described_class.new.show_presenter).to eq(RasterWorkShowPresenter)
    end
  end
end
