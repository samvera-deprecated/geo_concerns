require 'spec_helper'

describe CurationConcerns::RasterWorksController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:raster_work) { FactoryGirl.create(:raster_work, user: user, title: ['Raster Work Title']) }
  let(:reloaded) { raster_work.reload }
  let!(:sipity_entity) do
    create(:sipity_entity, proxy_for_global_id: raster_work.to_global_id.to_s)
  end

  describe "#show" do
    before do
      sign_in user
    end
    context "when there's a parent image work" do
      let(:parent_image_work) { FactoryGirl.create(:image_work, user: user) }
      let!(:parent_sipity_entity) do
        create(:sipity_entity, proxy_for_global_id: parent_image_work.to_global_id.to_s)
      end
      it "is a success" do
        parent_image_work.ordered_members << raster_work
        parent_image_work.save
        raster_work.update_index

        get :show, params: { id: raster_work.id }
        expect(response).to be_success
      end
    end
  end

  describe "#show_presenter" do
    it "is a raster work show presenter" do
      expect(described_class.new.show_presenter).to eq(GeoConcerns::RasterWorkShowPresenter)
    end
  end

  describe '#form_class' do
    it 'returns the raster work form class' do
      expect(described_class.new.form_class). to eq(CurationConcerns::RasterWorkForm)
    end
  end
end
