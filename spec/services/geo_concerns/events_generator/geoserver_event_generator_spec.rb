require 'spec_helper'

RSpec.describe GeoConcerns::EventsGenerator::GeoserverEventGenerator do
  subject { described_class.new(rabbit_connection) }
  let(:rabbit_connection) { instance_double(GeoConcerns::RabbitMessagingClient, publish: true) }
  let(:file_set) { FactoryGirl.build(:vector_file) }
  let(:visibility) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
  let(:attributes) { { id: 'geo-work-1',
                       title: ['Geo Work'],
                       description: ['geo work'],
                       temporal: ['2011'] }
  }

  describe "#derivatives_created" do
    it "publishes a persistent JSON message" do
      file_set.save
      expected_result = {
        "id" => file_set.id,
        "event" => "CREATED",
        "exchange" => "geoserver"
      }
      subject.derivatives_created(file_set)
      expect(rabbit_connection).to have_received(:publish).with(expected_result.to_json)
    end
  end

  describe "#record_updated" do
    it "publishes a persistent JSON message with new title" do
      file_set.title = ["New Geo Work"]
      file_set.save!
      expected_result = {
        "id" => file_set.id,
        "event" => "UPDATED",
        "exchange" => "geoserver"
      }
      subject.record_updated(file_set)
      expect(rabbit_connection).to have_received(:publish).with(expected_result.to_json)
    end
  end
end
