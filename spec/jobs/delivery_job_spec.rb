require 'spec_helper'
require 'uri'

describe GeoConcerns::DeliveryJob do
  let(:file_set) { double(FileSet, id: 'abc123') }

  context '#perform' do
    context 'local file' do
      let(:content_url) { 'file:/somewhere-to-display-copy' }
      it 'delegates to DeliveryService' do
        dbl = double
        expect(GeoConcerns::DeliveryService).to receive(:new).and_return(dbl)
        expect(dbl).to receive(:publish).with(file_set.id, URI(content_url).path)
        subject.perform(file_set, content_url)
      end
    end
    context 'remote file' do
      let(:content_url) { 'http://somewhere/to-display-copy' }
      it 'errors out' do
        expect(GeoConcerns::DeliveryService).not_to receive(:new)
        expect { subject.perform(file_set, content_url) }.to raise_error(NotImplementedError, /Only supports file URLs/)
      end
    end
  end
end
