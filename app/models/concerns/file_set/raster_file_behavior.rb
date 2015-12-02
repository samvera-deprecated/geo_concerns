# Attributes and methods for raster files
module RasterFileBehavior
  extend ActiveSupport::Concern
  include ::GeoreferencedBehavior
  # Retrieve the Raster Work of which this Object is a member
  # @return [GeoConcerns::Raster]
  def raster_work
    generic_works.select { |parent| parent.class.included_modules.include?(::RasterWorkBehavior) }.to_a
  end
end
