require 'simple_mapnik'

module GeoConcerns
  module Processors
    module Mapnik
      extend ActiveSupport::Concern

      included do
        def self.mapnik_vector_thumbnail(in_path, out_path, options)
          vector_info = GeoConcerns::Processors::Vector::Info.new(in_path)
          options[:name] = vector_info.name
          SimpleMapnik.register_datasources '/usr/local/lib/mapnik/input'
          map = SimpleMapnik::Map.new(*mapnik_size(options))
          map.load_string(mapnik_config(in_path, options).xml)
          map.zoom_all
          map.to_file out_path
        end

        def self.mapnik_size(options)
          options[:output_size].split(' ').map(&:to_i)
        end

        def self.mapnik_config(in_path, options)
          path_name = "#{in_path}/#{options[:name]}"
          SimpleMapnik::Config.new(path_name)
        end
      end
    end
  end
end
