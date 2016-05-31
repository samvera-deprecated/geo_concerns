require 'spec_helper'

describe CurationConcerns::FileSetsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

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
end
