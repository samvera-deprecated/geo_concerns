module BasicGeoMetadata
  extend ActiveSupport::Concern

  included do

    # bounding box
    property :georss_box, predicate: ::RDF::URI.new("http://www.georss.org/georss/box"), multiple: false do |index|
      index.as :stored_searchable
    end
    
    validates_presence_of :georss_box,  message: 'Your work must have a bbox.'
  end
end
