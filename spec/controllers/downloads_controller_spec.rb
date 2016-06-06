require 'spec_helper'

describe DownloadsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  subject { described_class.new }

  before(:each) do
    allow(subject).to receive(:params).and_return(params)
  end

  describe '#load_file' do
    context 'with a default file' do
      let(:params) { {} }

      it 'returns default file' do
        expect(subject).to receive(:default_file).and_return('path')
        expect(subject.load_file).to eq('path')
      end
    end

    context 'with a thumbnail file' do
      let(:params) { { file: 'thumbnail' } }
      let(:asset) { double }
      before do
        allow(subject).to receive(:asset).and_return(asset)
        allow(File).to receive(:exist?).and_return(true)
      end

      it 'calls GeoConcerns::DerivativePath and returns the thumb path' do
        expect(GeoConcerns::DerivativePath).to receive(:derivative_path_for_reference).and_return('path')
        expect(subject.load_file).to eq('path')
      end
    end
  end
end
