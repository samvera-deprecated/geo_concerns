module GeoConcerns
  module Discovery
    class DocumentBuilder
      class DocumentPath
        attr_reader :geo_concern
        def initialize(geo_concern)
          @geo_concern = geo_concern
        end

        # Returns url for geo concern show page.
        # @return [String] geo concern show page url
        def to_s
          helper.polymorphic_url(geo_concern, host: host, protocol: protocol)
        end

        # Returns url for downloading the original file.
        # @return [String] original file download url
        def file_download
          return unless file_set
          helper.download_url(file_set, host: host, protocol: protocol)
        end

        # Returns url for downloading the metadata file.
        # @param [String] metadata file format to download
        # @return [String] metadata download url
        def metadata_download(format)
          return unless metadata_file_set
          path = helper.download_url(metadata_file_set, host: host, protocol: protocol)
          mime_type = metadata_file_set.solr_document[:geo_mime_type_ssim].first
          path if MetadataFormatService.label(mime_type) == format
        end

        # Returns url for thumbnail image.
        # @return [String] thumbnail url
        def thumbnail
          return unless file_download
          "#{file_download}?file=thumbnail"
        end

        private

          # Returns the first geo file set presenter attached to work.
          # @return [FileSetPresenter] geo file set presenter
          def file_set
            return unless geo_concern.geo_file_set_presenters
            geo_concern.geo_file_set_presenters.first
          end

          # Returns the first metadata file set presenter attached to work.
          # @return [FileSetPresenter] metadata file set presenter
          def metadata_file_set
            return unless geo_concern.external_metadata_file_set_presenters
            geo_concern.external_metadata_file_set_presenters.first
          end

          # Instantiates a DocumentHelper object.
          # Used for access to url_helpers and poymorphic routes.
          # @return [DocumentHelper] document helper
          def helper
            @helper ||= DocumentHelper.new
          end

          # Indicates if the ssl is enabled.
          # @return [Boolean] use ssl
          def ssl?
            geo_concern.request.protocol == 'https://'
          end

          # Returns protocol to use in url. Depends on ssl status.
          # @return [Boolean] http protocol
          def protocol
            if ssl?
              :https
            else
              :http
            end
          end

          # Returns hostname (with port) to use in url.
          # @return [String] hostname
          def host
            geo_concern.request.host_with_port
          end
      end
    end
  end
end
