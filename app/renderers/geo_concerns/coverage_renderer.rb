module GeoConcerns
  class CoverageRenderer < CurationConcerns::Renderers::AttributeRenderer
    include BoundingBoxHelper

    def render
      coverage = values.first if values
      return '' unless coverage
      markup(coverage).html_safe
    end

    private

      def markup(coverage)
        markup = ''
        markup << %(<tr><th>#{label}</th>\n<td id='accordion'><ul class='tabular'>)
        markup << %(<div id='bbox' class='collapse in'></div>)
        markup << bbox_display_inputs
        markup << bbox_script_tag(coverage)
        markup << toggle_button
        markup << %(</ul></td></tr>)
        markup
      end

      def toggle_button
        %(
          <a data-toggle='collapse' data-parent='accordion' href='#bbox' class='btn btn-default'>
           Toggle Map</a>
          )
      end

      def bbox_script_tag(coverage)
        %(
          <script>
            boundingBoxSelector({coverage: '#{coverage}', readonly: true});
          </script>
        )
      end
  end
end
