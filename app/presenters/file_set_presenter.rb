class FileSetPresenter < CurationConcerns::FileSetPresenter
  include CurationConcerns::Serializers
  
  def label
    nil
  end

  def state_badge
    StateBadge.new(solr_document).render
  end
end
