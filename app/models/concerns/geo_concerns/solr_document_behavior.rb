module GeoConcerns
  module SolrDocumentBehavior
    extend ActiveSupport::Concern
    include CurationConcerns::SolrDocumentBehavior

    # @return [Array<String>]
    def spatial
      fetch(Solrizer.solr_name('spatial'), [])
    end

    # @return [Array<String>]
    def temporal
      fetch(Solrizer.solr_name('temporal'), [])
    end

    # @return [String]
    def issued
      fetch(Solrizer.solr_name('issued'), nil)
    end

    # @return [String]
    def coverage
      fetch(Solrizer.solr_name('coverage'), nil)
    end

    # @return [String]
    def provenance
      first(Solrizer.solr_name('provenance'))
    end

    # @return [DateTime]
    def layer_modified
      # TODO: `date_modified` isn't working correctly -- it's stored as a string not a date
      # @see 'https://github.com/projecthydra/curation_concerns/issues/957'
      dt = first(Solrizer.solr_name('system_modified', :stored_sortable, type: :date))
      dt.nil? ? nil : DateTime.parse(dt).utc
    end
  end
end
