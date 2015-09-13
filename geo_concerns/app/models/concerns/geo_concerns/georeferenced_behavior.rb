module GeoConcerns
  module GeoreferencedBehavior
    extend ActiveSupport::Concern

    PREFIXES = {
      ogc: 'http://www.opengis.net/def/dataType/OGC/1.1/'
    }

    included do
      property :crs, predicate: ::RDF::URI.new(PREFIXES[:ogc] + 'crsURI'), multiple: false do |index|
        index.as :stored_searchable
      end

      # validates :crs, presence: { message: 'Your work must have a CRS.' }
    end
  end
end
