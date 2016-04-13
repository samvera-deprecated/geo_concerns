module GeoConcerns
  module Processors
    module Vector
      class Simple < Hydra::Derivatives::Processors::Processor
        include Hydra::Derivatives::Processors::ShellBasedProcessor
        include GeoConcerns::Processors::BaseGeoProcessor

        def self.encode(path, options, output_file)
          encode_vector(path, options, output_file)
        end

        def self.encode_vector(in_path, options, out_path)
          tiff_path = "#{File.dirname(in_path)}/out.tif"
          execute rasterize(in_path, options, tiff_path)
          execute translate(tiff_path, options, out_path)
          File.unlink(tiff_path)
          File.unlink("#{out_path}.aux.xml")
        end
      end
    end
  end
end
