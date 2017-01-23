require 'active_support/core_ext/hash/indifferent_access'

module GeoConcerns
  module Discovery
    class DocumentBuilder
      class Wxs
        attr_reader :geo_concern
        def initialize(geo_concern)
          @geo_concern = geo_concern
          @config = GeoConcerns::GeoServer.config[visibility].try(:with_indifferent_access)
        end

        # Returns the identifier to use with WMS/WFS/WCS services.
        # @return [String] wxs indentifier
        def identifier
          return unless geo_file_set?
          return file_set.id unless @config && visibility
          "#{@config[:workspace]}:#{file_set.id}" if @config[:workspace]
        end

        # Returns the wms server url.
        # @return [String] wms server url
        def wms_path
          return unless @config && visibility && geo_file_set?
          "#{path}/#{@config[:workspace]}/wms"
        end

        # Returns the wfs server url.
        # @return [String] wfs server url
        def wfs_path
          return unless @config && visibility && geo_file_set?
          "#{path}/#{@config[:workspace]}/wfs"
        end

        private

          # Gets the representative file set.
          # @return [FileSet] representative file set
          def file_set
            @file_set ||= begin
              representative_id = geo_concern.solr_document.representative_id
              file_set_id = [representative_id]
              geo_concern.member_presenters(file_set_id).first
            end
          end

          # Tests if the file set is a geo file set.
          # @return [Bool]
          def geo_file_set?
            return false unless file_set
            @file_set_ids ||= geo_concern.geo_file_set_presenters.map(&:id)
            @file_set_ids.include? file_set.id
          end

          # Returns the file set visibility if it's open and authenticated.
          # @return [String] file set visibility
          def visibility
            return unless file_set
            visibility = file_set.solr_document.visibility
            visibility if valid_visibilities.include? visibility
          end

          def valid_visibilities
            [Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC,
             Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED]
          end

          # Geoserver base url.
          # @return [String] geoserver base url
          def path
            @config[:url].chomp('/rest')
          end
      end
    end
  end
end
