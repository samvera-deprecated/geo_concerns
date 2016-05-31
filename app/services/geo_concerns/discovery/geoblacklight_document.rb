require 'json-schema'

module GeoConcerns
  module Discovery
    class GeoblacklightDocument < AbstractDocument
      # Implements the to_hash method on the abstract document.
      # @param _args [Array<Object>] arguments needed for the renderer, unused here
      # @return [Hash] geoblacklight document as a hash
      def to_hash(_args = nil)
        document
      end

      # Implements the to_json method on the abstract document.
      # @param _args [Array<Object>] arguments needed for the json renderer, unused here
      # @return [String] geoblacklight document as a json string
      def to_json(_args = nil)
        document.to_json
      end

      private

        # Builds the geoblacklight document hash.
        # @return [Hash] geoblacklight document as a hash
        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        def document_hash
          {
            uuid: id,
            dc_identifier_s: identifier,
            dc_title_s: title.first,
            dc_description_s: description,
            dc_rights_s: rights,
            dct_provenance_s: provenance.first,
            dc_creator_sm: creator,
            dc_language_s: language.first,
            dc_publisher_s: publisher.first,
            dc_subject_sm: subject,
            dct_spatial_sm: spatial,
            dct_temporal_sm: temporal,
            layer_slug_s: slug,
            georss_box_s: geo_rss_coverage,
            solr_geom: solr_coverage,
            solr_year_i: layer_year,
            layer_modified_dt: date_modified,
            layer_id_s: wxs_identifier,
            dct_references_s: clean_document(references).to_json,
            layer_geom_type_s: geom_type,
            dc_format_s: process_format_codes(format)
          }
        end
        # rubocop:enable Metrics/LineLength, Metrics/AbcSize

        # Builds the dct_references hash.
        # @return [Hash] geoblacklight references as a hash
        def references
          {
            'http://schema.org/url' => url,
            'http://www.opengis.net/cat/csw/csdgm' => fgdc,
            'http://www.isotc211.org/schemas/2005/gmd/' => iso19139,
            'http://www.loc.gov/mods/v3' => mods,
            'http://schema.org/downloadUrl' => download,
            'http://schema.org/thumbnailUrl' => thumbnail
          }
        end

        # Returns the geoblacklight rights field based on work visibility.
        # @return [String] geoblacklight access rights
        def rights
          if access_rights == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
            'Public'
          else
            'Restricted'
          end
        end

        # Transforms shapfile, tiff, and arc grid format codes into geoblacklight format codes.
        # @return [String] geoblacklight format codes
        def process_format_codes(format)
          case format
          when 'ESRI Shapefile'
            'Shapefile'
          when 'GTiff'
            'GeoTIFF'
          when 'AIG'
            'ArcGRID'
          else
            format
          end
        end

        # Returns the location of geoblacklight json schema document.
        # @return [String] geoblacklight json schema document path
        def schema
          Rails.root.join('config', 'discovery', 'geoblacklight_schema.json').to_s
        end

        # Validates the geoblacklight document against the json schema.
        # @return [Boolean] is the document valid?
        def valid?(doc)
          JSON::Validator.validate(schema, doc, validate_schema: true)
        end

        # Returns a hash of errors from json schema validation.
        # @return [Hash] json schema validation errors
        def schema_errors(doc)
          { error: JSON::Validator.fully_validate(schema, doc) }
        end

        # Cleans the geoblacklight document hash by removing unused fields,
        # then validates it again a json schema. If there are errors, an
        # error hash is returned, otherwise, the cleaned doc is returned.
        # @return [Hash] geoblacklight document hash or error hash
        def document
          clean = clean_document(document_hash)
          if valid?(clean)
            clean
          else
            schema_errors(clean)
          end
        end
    end
  end
end
