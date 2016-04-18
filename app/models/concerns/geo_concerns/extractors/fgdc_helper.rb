module GeoConcerns
  module Extractors
    module FgdcHelper
      def extract_fgdc_metadata(doc)
        GeoConcerns::Extractors::FgdcMetadataExtractor.new(doc).to_hash
      end
    end
  end
end
