# Undesirable monkey patch we don't want to do.
require 'curation_concerns/derivative_path'
module CurationConcerns
  class DerivativePath
    def extension
      case destination_name
      when 'thumbnail'
        ".#{MIME::Types.type_for('jpg').first.extensions.first}"
      when 'display_raster'
        '.tif'
      when 'display_vector'
        '.zip'
      else
        ".#{destination_name}"
      end
    end
  end
end
