class FileSetPresenter < CurationConcerns::FileSetPresenter
  include CurationConcerns::Serializers
  def label
    nil
  end
end
