# Attributes and methods for vector files
module VectorFileBehavior
  extend ActiveSupport::Concern
  include ::GeoreferencedBehavior
  # Retrieve the Vector Work of which this Object is a member
  # @return [GeoConcerns::VectorWork]
  def vector_work
    generic_works.select { |parent| parent.class.included_modules.include?(::VectorWorkBehavior) }.to_a
  end
end
