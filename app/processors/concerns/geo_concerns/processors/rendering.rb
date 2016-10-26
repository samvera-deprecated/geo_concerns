require 'simpler_tiles'

module GeoConcerns
  module Processors
    module Rendering
      extend ActiveSupport::Concern
      included do
        # Renders a thumbnail from a vector dataset.
        # @param in_path [String] file input path
        # @param out_path [String] processor output file path
        # @param options [Hash] creation options
        def self.vector_thumbnail(in_path, out_path, options)
          map = GeoConcerns::Processors::Rendering.simple_tiles_map(in_path, options)
          File.open(out_path, 'wb') { |f| f.write map.to_png }
        end
      end

      class << self
        # Builds a simple tiles map from a shapefile.
        # @param in_path [String] file input path
        # @param options [Hash] creation
        # @return [SimplerTiles::Map] simple tiles map
        def simple_tiles_map(in_path, options)
          assign_rendering_options(in_path, options)
          size = rendering_size(options)
          SimplerTiles::Map.new do |m|
            m.srs     = 'EPSG:4326'
            m.bgcolor = SimplerTiles.config.bg_color
            m.width   = size[0]
            m.height  = size[1]
            m.set_bounds(*simple_tiles_bounds(options))
            add_shapefile_layer(in_path, m)
          end
        end

        private

          # Adds a shapefile layer to a simple tiles map.
          # @param in_path [String] file input path
          # @param options [Hash] creation options
          def add_shapefile_layer(in_path, map)
            Dir.glob("#{in_path}/*.shp").each do |shp|
              map.layer shp do |l|
                l.query "select * from '#{File.basename shp, '.shp'}'" do |q|
                  q.styles SimplerTiles.config.to_h
                end
              end
            end
          end

          # Re-orders options bounds for use with a simple tiles map.
          # @param options [Hash] creation options
          # @return [Array] simple tiles map bounds
          def simple_tiles_bounds(options)
            [options[:bounds][:east],
             options[:bounds][:north],
             options[:bounds][:west],
             options[:bounds][:south]]
          end

          # Transforms the size directive into an array.
          # @param options [Hash] creation options
          # @return [Array] derivative size
          def rendering_size(options)
            options[:output_size].split(' ').map(&:to_i)
          end

          # Assigns new values from the vector info command to the creation options hash.
          # @param in_path [String] file input path
          # @param options [Hash] creation options
          def assign_rendering_options(in_path, options)
            vector_info = GeoConcerns::Processors::Vector::Info.new(in_path)
            options[:name] = vector_info.name
            options[:bounds] = vector_info.bounds
          end
      end
    end
  end
end
