require 'spec_helper'

describe CurationConcerns::FileSetsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:parent) { FactoryGirl.build(:public_vector_work) }

  subject { described_class.new }

  describe '#new' do
    it 'renders a geo file set form if the parent is a geo work' do
      allow(subject).to receive(:geo?).and_return(true)
      expect(subject).to receive(:render).with('geo_concerns/file_sets/new')
      subject.new
    end
    it 'only render a geo file set form if the parent is a geo work' do
      allow(subject).to receive(:geo?).and_return(false)
      expect(subject).not_to receive(:render)
      subject.new
    end
  end

  describe 'messaging' do
    let(:messenger) { instance_double(GeoConcerns::EventsGenerator) }

    before do
      sign_in user
      allow(Messaging).to receive(:messenger).and_return(messenger)
    end

    context 'after updating metadata' do
      let!(:file_set) do
        file_set = FileSet.create do |gf|
          gf.apply_depositor_metadata(user)
          gf.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
        end
        parent.ordered_members << file_set
        parent.save
        file_set
      end

      after do
        file_set.destroy
      end

      it 'calls the record_updated messenger method' do
        expect(messenger).to receive(:record_updated)
        post :update, params: {
          id: file_set,
          file_set: { title: ['new_title'], keyword: [''], permissions_attributes: [{ type: 'person', name: 'archivist1', access: 'edit' }] }
        }
      end
    end

    context 'when destroying the file set' do
      let(:file_set) do
        file_set = FileSet.create! do |gf|
          gf.apply_depositor_metadata(user)
        end
        parent.ordered_members << file_set
        parent.save
        file_set
      end

      it 'calls the record_deleted messenger method' do
        expect(messenger).to receive(:record_deleted)
        delete :destroy, params: { id: file_set }
      end
    end
  end
end
