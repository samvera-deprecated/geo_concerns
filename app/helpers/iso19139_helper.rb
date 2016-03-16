module Iso19139Helper
  NS = {
    'xmlns:gmd' => 'http://www.isotc211.org/2005/gmd',
    'xmlns:gco' => 'http://www.isotc211.org/2005/gco'
  }.freeze

  # TODO: Migrate this code into an XSLT?
  # TODO: Need to support multivalued fields
  def extract_iso19139_metadata(doc)
    h = {}
    doc.at_xpath('//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString', NS).tap do |node|
      h[:title] = [node.text.strip]
    end

    doc.at_xpath('//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox', NS).tap do |node|
      w = node.at_xpath('gmd:westBoundLongitude/gco:Decimal', NS).text.to_f
      e = node.at_xpath('gmd:eastBoundLongitude/gco:Decimal', NS).text.to_f
      n = node.at_xpath('gmd:northBoundLatitude/gco:Decimal', NS).text.to_f
      s = node.at_xpath('gmd:southBoundLatitude/gco:Decimal', NS).text.to_f
      h[:coverage] = GeoConcerns::Coverage.new(n, e, s, w).to_s
    end

    doc.at_xpath('//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString', NS).tap do |node|
      h[:description] = [node.text.strip]
    end

    doc.xpath('//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue=\'originator\']', NS).each do |node|
      h[:creator] = begin
        [node.at_xpath('ancestor-or-self::*/gmd:individualName', NS).text.strip]
      rescue
        [node.at_xpath('ancestor-or-self::*/gmd:organisationName', NS).text.strip]
      end
    end

    # TODO: Not sure if custodian is the same as source
    doc.xpath('//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue=\'custodian\']', NS).each do |node|
      h[:source] = begin
        [node.at_xpath('ancestor-or-self::*/gmd:individualName', NS).text.strip]
      rescue
        [node.at_xpath('ancestor-or-self::*/gmd:organisationName', NS).text.strip]
      end
    end

    h
  end
end
