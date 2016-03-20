module GeoConcerns
  class FgdcMetadataExtractor
    attr_reader :doc
    def initialize(doc)
      @doc = doc
    end

    def to_hash
      metadata_required.merge(metadata_optional)
    end

    def metadata_required
      {
        coverage: coverage,
        creator: creators,
        description: [doc.at_xpath('//idinfo/descript/abstract').text],
        title: [doc.at_xpath('//idinfo/citation/citeinfo/title').text]
      }.compact
    end

    def metadata_optional
      {
        issued: issued,
        publisher: publishers,
        spatial: placenames,
        subject: keywords,
        temporal: timeperiods
      }.compact
    end

    def coverage
      doc.at_xpath('//idinfo/spdom/bounding').tap do |node|
        w = node.at_xpath('westbc').text.to_f
        e = node.at_xpath('eastbc').text.to_f
        n = node.at_xpath('northbc').text.to_f
        s = node.at_xpath('southbc').text.to_f
        return GeoConcerns::Coverage.new(n, e, s, w).to_s
      end
      nil
    end

    def issued
      doc.at_xpath('//idinfo/citation/citeinfo/pubdate').tap do |node|
        return node.text[0..3].to_i unless node.nil? # extract year only
      end
      nil
    end

    def timeperiods
      timeperiods = extract_multivalued('//idinfo/keywords/temporal/tempkey')
      doc.at_xpath('//idinfo/timeperd/timeinfo/mdattim/sngdate/caldate | //idinfo/timeperd/timeinfo/sngdate/caldate').tap do |node|
        timeperiods << node.text[0..3] unless node.nil? # extract year only
      end
      doc.at_xpath('//idinfo/timeperd/timeinfo/rngdates/begdate').tap do |node|
        timeperiods << node.text[0..3] unless node.nil? # extract year only
      end
      timeperiods.uniq!
      timeperiods.present? ? timeperiods : nil
    end

    def publishers
      extract_multivalued('//idinfo/citation/citeinfo/pubinfo/publish')
    end

    def creators
      extract_multivalued('//idinfo/citation/citeinfo/origin')
    end

    def placenames
      extract_multivalued('//idinfo/keywords/place/placekey')
    end

    def keywords
      keywords = extract_multivalued('//idinfo/keywords/theme/themekey')
      keywords.map! { |k| TOPIC_CATEGORIES[k.to_sym].present? ? TOPIC_CATEGORIES[k.to_sym] : k }
      keywords.uniq!
      keywords.present? ? keywords : nil
    end

    # ISO 19115 Topic Category
    TOPIC_CATEGORIES = {
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

    private

      def extract_multivalued(xpath)
        values = []
        doc.xpath(xpath).each do |node|
          values << node.text.strip
        end
        values.uniq!
        values.present? ? values : nil
      end
  end
end
