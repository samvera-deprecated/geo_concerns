require 'spec_helper'

describe GeoConcerns::DeliveryService do
  let(:id) { 'abc123' }
  let(:path) { 'somewhere-to-display-copy' }
  let(:file_set) { instance_double("FileSet") }
  let(:visibility) { 'open' }
  let(:service) { instance_double('GeoConcerns::Delivery::Geoserver') }

  subject { described_class.new file_set, path }

  before do
    allow(file_set).to receive(:visibility).and_return(visibility)
    allow(service).to receive(:visibility).and_return(visibility)
  end

  context '#publish' do
    it 'dispatches to Geoserver delivery' do
      expect(subject).to receive(:geoserver).and_return(service)
      expect(service).to receive(:publish)
      subject.publish
    end
  end
end
