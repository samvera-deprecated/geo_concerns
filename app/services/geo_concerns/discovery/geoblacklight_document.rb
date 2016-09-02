require 'json-schema'
require 'open-uri'

module GeoConcerns
  module Discovery
    # For details on the schema,
    # @see 'https://github.com/geoblacklight/geoblacklight/wiki/Schema'
    class GeoblacklightDocument < AbstractDocument
      GEOBLACKLIGHT_RELEASE_VERSION = 'v1.1.2'.freeze
      GEOBLACKLIGHT_SCHEMA = JSON.parse(open("https://raw.githubusercontent.com/geoblacklight/geoblacklight/#{GEOBLACKLIGHT_RELEASE_VERSION}/schema/geoblacklight-schema.json").read).freeze

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
        def document_hash
          document_hash_required.merge(document_hash_optional)
        end

        def document_hash_required
          {
            geoblacklight_version: '1.0',
            dc_identifier_s: id,
            layer_slug_s: slug,
            dc_title_s: title.first,
            solr_geom: solr_coverage,
            dct_provenance_s: provenance,
            dc_rights_s: rights
          }
        end

        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        def document_hash_optional
          {
            dc_description_s: description,
            dc_creator_sm: creator,
            dc_language_s: language.try(:first),
            dc_publisher_s: publisher.try(:first),
            dc_subject_sm: subject,
            dct_spatial_sm: spatial,
            dct_temporal_sm: temporal,
            solr_year_i: layer_year,
            layer_modified_dt: layer_modified,
            layer_id_s: wxs_identifier,
            dct_references_s: clean_document(references).to_json.to_s,
            layer_geom_type_s: geom_type,
            dc_format_s: process_format_codes(format),
            dct_issued_dt: issued
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

        # Returns the content of geoblacklight JSON-Schema document.
        # @return [Hash] geoblacklight json schema
        def schema
          GEOBLACKLIGHT_SCHEMA
        end

        # Validates the geoblacklight document against the json schema.
        # @return [Boolean] is the document valid?
        def valid?(doc)
          JSON::Validator.validate(schema, doc, fragment: '#/properties/layer')
        end

        # Returns a hash of errors from json schema validation.
        # @return [Hash] json schema validation errors
        def schema_errors(doc)
          { error: JSON::Validator.fully_validate(schema, doc, fragment: '#/properties/layer') }
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
