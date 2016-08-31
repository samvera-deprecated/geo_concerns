module GeoConcerns
  module BoundingBoxHelper
    ##
    # Builds HTML string for bounding box selector tool.
    # Calls boundingBoxSelector javascript function and
    # passes the id of the location input element that it binds to.
    # @param [Symbol] name of property that holds bounding box string
    # @return[String]
    def bbox(property)
      markup = ''
      markup << %(<div id='bbox'></div>)
      markup << bbox_display_inputs
      markup << bbox_script_tag(property)
      markup.html_safe
    end

    ##
    # Returns markup for a row of read only bounding box inputs.
    # @return[String]
    # rubocop:disable MethodLength
    def bbox_display_inputs
      %(
        <div class="row bbox-inputs">
          <div class="col-lg-3">
            <div class="input-group">
              <span class="input-group-addon">North</span>
              <input readonly id="bbox-north" type="text" class="form-control bbox-input">
            </div>
          </div>
          <div class="col-lg-3">
            <div class="input-group">
              <span class="input-group-addon">East</span>
              <input readonly id="bbox-east" type="text" class="form-control bbox-input">
            </div>
          </div>
          <div class="col-lg-3">
            <div class="input-group">
              <span class="input-group-addon">South</span>
              <input readonly id="bbox-south" type="text" class="form-control bbox-input">
            </div>
          </div>
          <div class="col-lg-3">
            <div class="input-group">
              <span class="input-group-addon">West</span>
              <input readonly id="bbox-west" type="text" class="form-control bbox-input">
            </div>
          </div>
        </div>
      )
    end
    # rubocop:enable MethodLength

    ##
    # Returns script tag markup for loading the bounding box selector.
    # @param[Symbol] name of property that holds bounding box string
    # @return[String] script tag
    def bbox_script_tag(property)
      %(
        <script>
          boundingBoxSelector({inputId: #{bbox_input_id(property)}});
        </script>
      )
    end

    ##
    # Returns id of location input that is bound to bbox selector.
    # @param [Symbol] name of property that holds bounding box string
    # @return[String] id of location input element
    def bbox_input_id(property)
      "#{curation_concern.class.name.underscore}_#{property}"
    end
  end
end
