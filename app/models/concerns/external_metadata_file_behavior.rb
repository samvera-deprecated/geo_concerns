# Attributes and methods for vector metadata files
module ExternalMetadataFileBehavior
  extend ActiveSupport::Concern

  included do
    # Specifies the metadata standard to which the metadata file conforms
    # @see http://dublincore.org/documents/dcmi-terms/#terms-conformsTo
    property :conforms_to, predicate: ::RDF::DC.conformsTo, multiple: false do |index|
      index.as :stored_searchable, :facetable
    end

    type [Hydra::PCDM::Vocab::PCDMTerms.Object,
          Hydra::Works::Vocab::WorksTerms.GenericFile,
          'http://projecthydra.org/geoconcerns/models#ExternalMetadataFile']
  end

  # Defines type by what it is and isn't
  # @return [Boolean]
  def image_work?
    false
  end

  def image_file?
    false
  end

  def raster_work?
    false
  end

  def raster_file?
    false
  end

  def vector_work?
    false
  end

  def vector_file?
    false
  end

  def external_metadata_file?
    true
  end

  # Extracts properties from the constitutent external metadata file
  # @return [Hash]
  def extract_metadata
    fn = "extract_#{conforms_to.downcase}_metadata"
    if respond_to?(fn.to_sym)
      send(fn, metadata_xml)
    else
      fail "Unsupported metadata standard: #{conforms_to}"
    end
  end

  # Retrives data from PCDM::File
  def metadata_xml
    Nokogiri::XML.new # TODO: Get XML from file
  end

  # TODO: Migrate this code into an XSLT? Need to support multivalued fields
  def extract_iso19139_metadata(doc)
    ns = {
      'xmlns:gmd' => 'http://www.isotc211.org/2005/gmd',
      'xmlns:gco' => 'http://www.isotc211.org/2005/gco'
    }
    h = {}
    doc.xpath('//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString', ns).each do |node|
      h[:title] = [node.text.strip]
    end

    doc.xpath('//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox', ns).each do |node|
      w = node.at_xpath('gmd:westBoundLongitude/gco:Decimal', ns).text.to_f
      e = node.at_xpath('gmd:eastBoundLongitude/gco:Decimal', ns).text.to_f
      n = node.at_xpath('gmd:northBoundLatitude/gco:Decimal', ns).text.to_f
      s = node.at_xpath('gmd:southBoundLatitude/gco:Decimal', ns).text.to_f
      h[:bounding_box] = "#{s} #{w} #{n} #{e}"
    end

    doc.xpath('//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString', ns).each do |node|
      h[:description] = [node.text.strip]
    end

    doc.xpath('//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue=\'originator\']', ns).each do |node|
      begin
        h[:creator] = [node.at_xpath('ancestor-or-self::*/gmd:individualName', ns).text.strip]
      rescue
        h[:creator] = [node.at_xpath('ancestor-or-self::*/gmd:organisationName', ns).text.strip]
      end
    end

    # TODO: Not sure if custodian is the same as source
    doc.xpath('//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue=\'custodian\']', ns).each do |node|
      begin
        h[:source] = [node.at_xpath('ancestor-or-self::*/gmd:individualName', ns).text.strip]
      rescue
        h[:source] = [node.at_xpath('ancestor-or-self::*/gmd:organisationName', ns).text.strip]
      end
    end

    h
  end

  def extract_fgdc_metadata(doc)
    {
      title: doc.at_xpath('//idinfo/citation/citeinfo/title').text
    }
  end

  def extract_mods_metadata(doc)
    ns = {
      'xmlns:mods' => 'http://www.loc.gov/mods/v3'
    }
    {
      title: doc.at_xpath('//mods:mods/mods:titleInfo/mods:title', ns).text
    }
  end
end
