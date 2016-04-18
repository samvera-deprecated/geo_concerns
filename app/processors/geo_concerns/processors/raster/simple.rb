module GeoConcerns
  module Processors
    module Raster
      class Simple < Hydra::Derivatives::Processors::Processor
        include Hydra::Derivatives::Processors::ShellBasedProcessor
        include GeoConcerns::Processors::BaseGeoProcessor

        def self.encode(path, options, output_file)
          encode_raster(path, options, output_file)
        end

        def self.encode_raster(in_path, options, out_path)
          execute translate(in_path, options, out_path)
          File.unlink("#{out_path}.aux.xml")
        end
      end
    end
  end
end
