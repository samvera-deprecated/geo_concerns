require 'active_support/core_ext/hash/indifferent_access'
require 'rgeoserver'
require 'yaml'

module GeoConcerns
  module Delivery
    class Geoserver
      DEFAULT_CONFIG = {
        url: 'http://localhost:8181/geoserver/rest',
        user: 'admin',
        password: 'geoserver'
      }.with_indifferent_access.freeze

      attr_reader :config

      def initialize
        begin
          data = File.read(Rails.root.join('config', 'geoserver.yml'))
          @config = YAML.load(data)['geoserver'].with_indifferent_access.freeze
        rescue Errno::ENOENT
          @config = DEFAULT_CONFIG
        end
        validate!
      end

      def catalog
        @catalog ||= RGeoServer.catalog(config)
      end

      def publish(id, filename, type = :vector)
        case type
        when :vector
          publish_vector(id, filename)
        when :raster
          publish_raster(id, filename)
        else
          raise ArgumentError, "Unknown file type #{type}"
        end
      end

      private

        def validate!
          %w(url user password).map(&:to_sym).each do |k|
            raise ArgumentError, "Missing #{k} in configuration" unless config[k].present?
          end
        end

        def publish_vector(id, filename)
          raise ArgumentError, "Not ZIPed Shapefile: #{filename}" unless filename =~ /\.zip$/

          workspace = RGeoServer::Workspace.new catalog, name: 'geo'
          workspace.save if workspace.new?
          datastore = RGeoServer::DataStore.new catalog, workspace: workspace, name: id
          datastore.upload_file filename, publish: true
        end

        def publish_raster(_id, filename)
          raise ArgumentError, "Not GeoTIFF: #{filename}" unless filename =~ /\.tif$/
          raise NotImplementedError
        end
    end
  end
end
