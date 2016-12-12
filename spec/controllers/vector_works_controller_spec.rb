require 'spec_helper'

describe CurationConcerns::VectorWorksController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:vector_work) { FactoryGirl.create(:vector_work, user: user, title: ['Vector Work Title']) }
  let(:reloaded) { vector_work.reload }
  let!(:sipity_entity) do
    create(:sipity_entity, proxy_for_global_id: vector_work.to_global_id.to_s)
  end

  describe "#show" do
    before do
      sign_in user
    end
    context "when there's a parent raster work" do
      let(:parent_raster_work) { FactoryGirl.create(:raster_work, user: user) }
      let!(:parent_sipity_entity) do
        create(:sipity_entity, proxy_for_global_id: parent_raster_work.to_global_id.to_s)
      end
      it "is a success" do
        parent_raster_work.ordered_members << vector_work
        parent_raster_work.save
        vector_work.update_index

        get :show, params: { id: vector_work.id }
        expect(response).to be_success
      end
    end
  end

  describe "#show_presenter" do
    it "is a vector work show presenter" do
      expect(described_class.new.show_presenter.name).to eq("GeoConcerns::VectorWorkShowPresenter")
    end
  end

  describe '#form_class' do
    it 'returns the raster work form class' do
      expect(described_class.new.form_class). to eq(CurationConcerns::VectorWorkForm)
    end
  end

  describe '#geoblacklight' do
    # Tell RSpec where to find the geoblacklight route.
    routes { GeoConcerns::Engine.routes }
    let(:builder) { double }
    before do
      sign_in user
      allow(GeoConcerns::Discovery::DocumentBuilder).to receive(:new).and_return(builder)
    end

    context 'with a valid geoblacklight document' do
      before do
        allow(builder).to receive(:to_hash).and_return(id: 'test')
      end

      it 'renders the document' do
        get :geoblacklight, params: { id: vector_work.id, format: :json }
        expect(response).to be_success
      end
    end

    context 'with an invalid geoblacklight document' do
      before do
        allow(builder).to receive(:to_hash).and_return(error: 'problem')
      end

      it 'returns an error message with a 404 status' do
        get :geoblacklight, params: { id: vector_work.id, format: :json }
        expect(response.body).to include('problem')
        expect(response.status).to eq(404)
      end
    end
  end
end
