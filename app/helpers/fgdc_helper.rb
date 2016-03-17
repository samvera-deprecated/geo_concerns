module FgdcHelper
  def extract_fgdc_metadata(doc)
    extract_fgdc_metadata_required(doc).merge!(
      extract_fgdc_metadata_optional(doc))
  end

  private

    def extract_fgdc_metadata_required(doc)
      h = {
        title: [doc.at_xpath('//idinfo/citation/citeinfo/title').text],
        description: [doc.at_xpath('//idinfo/descript/abstract').text]
      }

      doc.at_xpath('//idinfo/citation/citeinfo/origin').tap do |node|
        h[:creator] = [node.text.strip] unless node.nil?
      end

      doc.at_xpath('//idinfo/spdom/bounding').tap do |node|
        w = node.at_xpath('westbc').text.to_f
        e = node.at_xpath('eastbc').text.to_f
        n = node.at_xpath('northbc').text.to_f
        s = node.at_xpath('southbc').text.to_f
        h[:coverage] = GeoConcerns::Coverage.new(n, e, s, w).to_s
      end

      h
    end

    def extract_fgdc_metadata_optional(doc)
      h = {}
      doc.at_xpath('//idinfo/citation/citeinfo/pubdate').tap do |node|
        h[:issued] = node.text[0..3].to_i unless node.nil? # extract year only
      end
      h[:temporal] = extract_fgdc_timeperiods(doc)
      h[:spatial] = extract_fgdc_placenames(doc)
      h[:subject] = extract_fgdc_keywords(doc)
      h
    end

    def extract_fgdc_timeperiods(doc)
      timeperiods = []
      doc.at_xpath('//idinfo/timeperd/timeinfo/mdattim/sngdate/caldate | //idinfo/timeperd/timeinfo/sngdate/caldate').tap do |node|
        timeperiods << node.text[0..3] unless node.nil? # extract year only
      end
      doc.at_xpath('//idinfo/timeperd/timeinfo/rngdates/begdate').tap do |node|
        timeperiods << node.text[0..3] unless node.nil? # extract year only
      end
      doc.xpath('//idinfo/keywords/temporal/tempkey').each do |node|
        timeperiods << node.text
      end
      timeperiods.uniq!
      timeperiods.present? ? timeperiods : nil
    end

    def extract_fgdc_placenames(doc)
      placenames = []
      doc.xpath('//idinfo/keywords/place/placekey').each do |node|
        placenames << node.text
      end
      placenames.uniq!
      placenames.present? ? placenames : nil
    end

    def extract_fgdc_keywords(doc)
      keywords = []
      doc.xpath('//idinfo/keywords/theme/themekey').each do |node|
        keywords << node.text
      end
      keywords.map! { |k| KEYWORD_ABBR[k.to_sym].present? ? KEYWORD_ABBR[k.to_sym] : k }
      keywords.uniq!
      keywords.present? ? keywords : nil
    end

    KEYWORD_ABBR = {
      farming: 'Farming',
      biota: 'Biology and Ecology',
      climatologyMeteorologyAtmosphere: 'Climatology, Meteorology and Atmosphere',
      boundaries: 'Boundaries',
      elevation: 'Elevation',
      environment: 'Environment',
      geoscientificinformation: 'Geoscientific Information',
      health: 'Health',
      imageryBaseMapsEarthCover: 'Imagery and Base Maps',
      intelligenceMilitary: 'Military',
      inlandWaters: 'Inland Waters',
      location: 'Location',
      oceans: 'Oceans',
      planningCadastre: 'Planning and Cadastral',
      structure: 'Structures',
      transportation: 'Transportation',
      utilitiesCommunication: 'Utilities and Communication',
      society: 'Society'
    }.freeze
end
