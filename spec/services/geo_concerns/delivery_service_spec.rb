require 'spec_helper'

describe GeoConcerns::DeliveryService do
  let(:id) { 'abc123' }
  let(:filename) { 'somewhere-to-display-copy' }

  context '#publish' do
    it 'dispatches to Geoserver delivery' do
      dbl = double
      expect(subject).to receive(:geoserver).and_return(dbl)
      expect(dbl).to receive(:publish).with(id, filename)
      subject.publish(id, filename)
    end
  end
end
