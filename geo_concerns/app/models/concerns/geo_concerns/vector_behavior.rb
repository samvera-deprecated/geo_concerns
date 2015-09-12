module GeoConcerns
  module VectorBehavior
    extend ActiveSupport::Concern
    include ::CurationConcerns::GenericWorkBehavior
    include ::CurationConcerns::BasicMetadata
    include ::GeoConcerns::BasicGeoMetadata
    include ::GeoConcerns::GeoreferencedBehavior

    included do
      # property :attributeTable, Array
      # ...

      # filters_association :members, as: :vector_files, condition: :concerns_vector_file?
    end

    def concerns_vector?
      true
    end

    def concerns_vector_file?
      false
    end
  end
end
