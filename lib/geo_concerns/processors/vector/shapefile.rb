module GeoConcerns
  module Processors
    module Vector
      class Shapefile < GeoConcerns::Processors::Vector::Simple
        include GeoConcerns::Processors::Unzip

        def self.encode(path, options, output_file)
          unzip(path, output_file) do |zip_path|
            encode_vector(zip_path, options, output_file)
          end
        end
      end
    end
  end
end
