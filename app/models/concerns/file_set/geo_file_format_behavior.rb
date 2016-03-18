module GeoFileFormatBehavior
  extend ActiveSupport::Concern

  included do
    # Specifies the format standard to which the file conforms
    # @see http://dublincore.org/documents/dcmi-terms/#terms-conformsTo
    property :conforms_to, predicate: ::RDF::Vocab::DC.conformsTo, multiple: false do |index|
      index.as :stored_searchable, :facetable
    end
  end

  def image_file?
    self.class.image_file_formats.include? conforms_to
  end

  def raster_file?
    self.class.raster_file_formats.include? conforms_to
  end

  def vector_file?
    self.class.vector_file_formats.include? conforms_to
  end

  def external_metadata_file?
    self.class.external_metadata_file_formats.include? conforms_to
  end

  def image_work?
    false
  end

  def raster_work?
    false
  end

  def vector_work?
    false
  end

  module ClassMethods
    def image_file_formats
      ['TIFF', 'IMAGE_FILE']
    end

    def raster_file_formats
      ['TIFF_GeoTIFF', 'RASTER_FILE']
    end

    def vector_file_formats
      ['SHAPEFILE', 'SHAPEFILE_ZIP', 'VECTOR_FILE']
    end

    def external_metadata_file_formats
      ['FGDC', 'ISO19139', 'MODS', 'EXTERNAL_METADATA_FILE']
    end
  end
end
