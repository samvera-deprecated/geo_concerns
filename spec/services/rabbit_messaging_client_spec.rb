require 'spec_helper'

RSpec.describe GeoConcerns::RabbitMessagingClient do
  subject { described_class.new(url) }
  let(:url) { "amqp://test.x.z.s:4000" }
  let(:config) { { 'events' => { 'exchange' => { 'geoblacklight' => 'gbl_events', 'geoserver' => 'geoserver_events' } } } }
  let(:exchange) { 'geoblacklight' }
  let(:message) { { exchange: exchange }.to_json }
  let(:channel) { instance_double(Bunny::Channel) }
  let(:bunny_session) { instance_double(Bunny::Session, create_channel: channel) }

  before do
    allow(Messaging).to receive(:config).and_return(config)
    allow(Bunny).to receive(:new).and_return(bunny_session)
    allow(bunny_session).to receive(:start)
  end

  describe "#publish" do
    context 'with a geoblacklight exchange type' do
      it 'calls the geoblacklight method' do
        expect(channel).to receive(:fanout).with('gbl_events', durable: true)
        subject.publish(message)
      end
    end

    context 'with a geoserver exchange type' do
      let(:exchange) { 'geoserver' }

      it 'calls the geoserver method' do
        expect(channel).to receive(:fanout).with('geoserver_events', durable: true)
        subject.publish(message)
      end
    end
  end
end
