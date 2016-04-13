module GeoConcerns
  module Processors
    module Unzip
      extend ActiveSupport::Concern

      included do
        # Unzips a file, invokes a block, and then deletes the unzipped file(s).
        # Use to wrap processor methods for geo file formats that
        # are zipped before uploading.
        #
        # @param path [String] file input path
        # @param output_file [String] processor output file path
        def self.unzip(path, output_file)
          basename = File.basename(output_file, File.extname(output_file))
          zip_out_path = "#{File.dirname(output_file)}/#{basename}_out"
          execute "unzip -qq -j -d \"#{zip_out_path}\" \"#{path}\""
          yield zip_out_path
          FileUtils.rm_rf(zip_out_path)
        end
      end
    end
  end
end
