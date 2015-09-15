
module GeoreferencedBehavior
  extend ActiveSupport::Concern

  PREFIXES = {
    bf: 'http://bibframe.org/vocab/'
  }

  included do
    property :crs, predicate: ::RDF::URI.new(PREFIXES[:bf] + 'cartographicProjection'), multiple: false do |index|
      index.as :stored_searchable
    end
  end
end
