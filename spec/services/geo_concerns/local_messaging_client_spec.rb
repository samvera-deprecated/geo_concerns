require 'spec_helper'

RSpec.describe GeoConcerns::LocalMessagingClient do
  subject { described_class.new }
  let(:config) { { 'events' => { 'exchange' => { 'geoblacklight' => 'gbl_events', 'geoserver' => 'geoserver_events' } } } }
  let(:exchange) { 'geoblacklight' }
  let(:message) { { exchange: exchange }.to_json }

  describe "#publish" do
    context 'with a geoblacklight exchange type' do
      it 'calls the geoblacklight method' do
        expect(GeoblacklightJob).to receive(:perform_later)
        subject.publish(message)
      end
    end

    context 'with a geoserver exchange type' do
      let(:exchange) { 'geoserver' }

      it 'calls the geoserver method' do
        expect(DeliveryJob).to receive(:perform_later)
        subject.publish(message)
      end
    end

    context 'with an unknown exchange type' do
      let(:exchange) { 'someexchange' }

      it 'logs an error' do
        expect(Rails.logger).to receive(:warn).with(/Unable to publish message/)
        subject.publish(message)
      end
    end
  end
end
