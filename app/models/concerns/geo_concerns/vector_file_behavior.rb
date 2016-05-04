module GeoConcerns
  # Attributes and methods for vector files
  module VectorFileBehavior
    extend ActiveSupport::Concern
    include ::GeoConcerns::GeoreferencedBehavior
    # Retrieve the Vector Work of which this Object is a member
    # @return [GeoConcerns::VectorWork]
    def vector_work
      parents.select do |parent|
        parent.class.included_modules.include?(::GeoConcerns::VectorWorkBehavior)
      end.to_a
    end
  end
end
