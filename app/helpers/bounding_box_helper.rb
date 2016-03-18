module BoundingBoxHelper
  ##
  # Builds HTML string for bounding box selector tool.
  # Calls boundingBoxSelector javascript function and
  # passes the id of the location input element that it binds to.
  # @param [Symbol] name of property that holds bounding box string
  # @return[String]
  def bbox(property)
    %(
      <div id='bbox'></div>
      <script>
        boundingBoxSelector({inputId: #{bbox_input_id(property)}});
      </script>
    ).html_safe
  end

  ##
  # Returns id of location input that is bound to bbox selector.
  # @param [Symbol] name of property that holds bounding box string
  # @return[String] id of location input element
  def bbox_input_id(property)
    "#{curation_concern.class.name.underscore}_#{property}"
  end
end
