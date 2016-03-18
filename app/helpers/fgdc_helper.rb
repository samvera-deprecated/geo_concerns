module FgdcHelper
  def extract_fgdc_metadata(doc)
    GeoConcerns::FgdcMetadataExtractor.new(doc).to_hash
  end
end
