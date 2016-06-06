require 'spec_helper'

describe CurationConcerns::RasterWorksController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:raster_work) { FactoryGirl.create(:raster_work, user: user, title: ['Raster Work Title']) }
  let(:reloaded) { raster_work.reload }

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
      expect(described_class.new.show_presenter).to eq(GeoConcerns::RasterWorkShowPresenter)
    end
  end
end
