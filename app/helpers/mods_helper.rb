module ModsHelper
  NS = {
    'xmlns:mods' => 'http://www.loc.gov/mods/v3'
  }.freeze
  def extract_mods_metadata(doc)
    {
      title: [doc.at_xpath('//mods:mods/mods:titleInfo/mods:title', NS).text],
      description: [doc.at_xpath('//mods:mods/mods:abstract', NS).text]
    }
  end
end
