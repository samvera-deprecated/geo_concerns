module GeoConcerns
  # Attributes and methods for raster files
  module RasterFileBehavior
    extend ActiveSupport::Concern
    include ::GeoConcerns::GeoreferencedBehavior
    # Retrieve the Raster Work of which this Object is a member
    # @return [GeoConcerns::Raster]
    def raster_work
      generic_works.select do |parent|
        parent.class.included_modules.include?(::GeoConcerns::RasterWorkBehavior)
      end.to_a
    end
  end
end
