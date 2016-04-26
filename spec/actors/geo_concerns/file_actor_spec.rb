require 'spec_helper'

describe GeoConcerns::FileActor do
  include ActionDispatch::TestProcess
  let(:user) { double }
  let(:file) { double }
  let(:file_set) { double }
  let(:actor) { described_class.new(file_set, 'test', user) }

  describe '#mime_type' do
    context 'there is a mime_type attribute on the file set' do
      it 'returns the file set mime type' do
        allow(file_set).to receive(:mime_type).and_return('text/plain; gdal-format=USGSDEM')
        expect(actor.mime_type(file)).to eq('text/plain; gdal-format=USGSDEM')
      end
    end

    context 'there is not a mime_type attribute on the file set' do
      it 'returns the file set mime type' do
        allow(file_set).to receive(:mime_type).and_return(nil)
        allow(file).to receive(:content_type).and_return('text/plain; gdal-format=USGSDEM')
        expect(actor.mime_type(file)).to eq('text/plain; gdal-format=USGSDEM')
      end
    end
  end
end
