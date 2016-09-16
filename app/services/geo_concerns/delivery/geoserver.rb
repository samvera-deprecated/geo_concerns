require 'active_support/core_ext/hash/indifferent_access'
require 'rgeoserver'
require 'yaml'
require 'erb'

module GeoConcerns
  module Delivery
    class Geoserver
      attr_reader :config, :workspace_name, :file_set, :file_path

      def initialize(file_set, file_path)
        @file_set = file_set
        @file_path = file_path
        @config = fetch_config
        @workspace_name = @config.delete(:workspace)
        validate!
      end

      def catalog
        @catalog ||= RGeoServer.catalog(config)
      end

      def publish
        case type
        when :vector
          publish_vector
        when :raster
          publish_raster
        end
      end

      private

        def fetch_config
          raise ArgumentError, "FileSet visibility must be open or authenticated" unless visibility

          data = ERB.new(File.read(Rails.root.join('config', 'geoserver.yml'))).result
          YAML.load(data)['geoserver'][visibility].with_indifferent_access
        end

        def visibility
          return file_set.visibility if file_set.visibility == 'open'
          return file_set.visibility if file_set.visibility == 'authenticated'
        end

        def validate!
          %w(url user password).map(&:to_sym).each do |k|
            raise ArgumentError, "Missing #{k} in configuration" unless config[k].present?
          end
        end

        def type
          return :vector if file_path =~ /\.zip$/
          return :raster if file_path =~ /\.tif$/
          raise ArgumentError, "Not a ZIPed Shapefile or GeoTIFF: #{file_path}"
        end

        def workspace
          workspace = RGeoServer::Workspace.new catalog, name: workspace_name
          workspace.save if workspace.new?
          workspace
        end

        def datastore
          RGeoServer::DataStore.new catalog, workspace: workspace, name: file_set.id
        end

        def publish_vector
          datastore.upload_file file_path, publish: true
        end

        def coveragestore
          RGeoServer::CoverageStore.new catalog, workspace: workspace, name: file_set.id
        end

        def publish_raster
          coveragestore.upload file_path
        end
    end
  end
end
