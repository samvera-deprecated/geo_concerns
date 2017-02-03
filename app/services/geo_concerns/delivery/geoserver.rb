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
        @workspace_name = @config[:workspace]
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
      rescue StandardError => e
        Rails.logger.error("GeoServer delivery job failed with: #{e}")
      end

      private

        def fetch_config
          raise ArgumentError, "FileSet visibility must be open or authenticated" unless visibility
          GeoConcerns::GeoServer.config[visibility]
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
          @datastore ||= RGeoServer::DataStore.new catalog, workspace: workspace,
                                                            name: file_set.id
        end

        def coveragestore
          @coveragestore ||= RGeoServer::CoverageStore.new catalog, workspace: workspace,
                                                                    name: file_set.id
        end

        def base_path(path)
          path.gsub(CurationConcerns.config.derivatives_path, '')
        end

        def shapefile_dir
          "#{File.dirname(file_path)}/#{File.basename(file_path, '.zip')}"
        end

        def persist_coveragestore
          url = "file:///#{@config[:derivatives_path]}#{base_path(file_path)}"
          coveragestore.url = url
          coveragestore.enabled = 'true'
          coveragestore.data_type = 'GeoTIFF'
          coveragestore.save
        end

        def persist_coverage
          coverage = RGeoServer::Coverage.new catalog, workspace: workspace,
                                                       coverage_store: coveragestore,
                                                       name: coveragestore.name
          coverage.title = coveragestore.name
          coverage.metadata_links = []
          coverage.save
        end

        def publish_vector
          # Delete existing shapefile
          FileUtils.rm_rf(shapefile_dir)

          # Unzip derivative shapefiles
          system "unzip -o #{file_path} -d #{shapefile_dir}"

          shape_path = Dir.glob("#{shapefile_dir}/*.shp").first
          raise Errno::ENOENT, 'Shapefile not found' unless shape_path
          url = "file:///#{@config[:derivatives_path]}#{base_path(shape_path)}"
          datastore.upload_external url, publish: true
        end

        def publish_raster
          persist_coveragestore
          persist_coverage
        end
    end
  end
end
