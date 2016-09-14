require 'spec_helper'
require 'uri'

describe GeoConcerns::DeliveryJob do
  let(:file_set) { double(FileSet, id: 'abc123') }

  context '#perform' do
    context 'local file' do
      let(:content_url) { 'file:/somewhere-to-display-copy' }
      let(:service) { instance_double('GeoConcerns::DeliveryService') }
      it 'delegates to DeliveryService' do
        expect(GeoConcerns::DeliveryService).to receive(:new).with(file_set, URI(content_url).path).and_return(service)
        expect(service).to receive(:publish)
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
