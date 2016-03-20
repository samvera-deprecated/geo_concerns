module GeoConcerns
  module SolrDocumentBehavior
    extend ActiveSupport::Concern

    def spatial
      fetch(Solrizer.solr_name('spatial'), [])
    end

    def temporal
      fetch(Solrizer.solr_name('temporal'), [])
    end

    def issued
      fetch(Solrizer.solr_name('issued'), nil)
    end

    def coverage
      fetch(Solrizer.solr_name('coverage'), nil)
    end

    def provenance
      fetch(Solrizer.solr_name('provenance'), nil)
    end
  end
end
