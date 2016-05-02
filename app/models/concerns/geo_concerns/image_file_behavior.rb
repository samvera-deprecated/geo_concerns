module GeoConcerns
  # Attributes and methods for image files
  module ImageFileBehavior
    extend ActiveSupport::Concern

    # Retrieve the Image Work of which this Object is a member
    # @return [GeoConcerns::ImageWork]
    def image_work
      parents.select do |parent|
        parent.class.included_modules.include?(::GeoConcerns::ImageWorkBehavior)
      end.to_a
    end
  end
end
