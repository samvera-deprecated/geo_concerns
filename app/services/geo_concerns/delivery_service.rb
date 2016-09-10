module GeoConcerns
  class DeliveryService
    attr_reader :geoserver

    def initialize
      @geoserver = GeoConcerns::Delivery::Geoserver.new
    end

    delegate :publish, to: :geoserver
  end
end
