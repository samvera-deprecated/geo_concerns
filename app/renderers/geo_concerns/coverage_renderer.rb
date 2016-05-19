module GeoConcerns
  class CoverageRenderer < CurationConcerns::Renderers::AttributeRenderer
    def render
      coverage = values.first if values
      return '' unless coverage
      markup(coverage).html_safe
    end

    private

      def markup(coverage)
        markup = ''
        markup << %(<tr><th>#{label}</th>\n<td id='accordion'><ul class='tabular'>)
        markup << value(coverage)
        markup << toggle_button
        markup << map(coverage)
        markup << %(</ul></td></tr>)
        markup
      end

      def value(coverage)
        attributes = microdata_object_attributes(field).merge(class: "attribute #{field}")
        %(<li#{html_attributes(attributes)}>#{attribute_value_to_html(coverage.to_s)})
      end

      def toggle_button
        %( <a data-toggle='collapse' data-parent='accordion' href='#bbox' class='btn btn-default'>
           Toggle Map</a>)
      end

      def map(coverage)
        %(<div id='bbox' class='collapse in'></div>
          <script>boundingBoxSelector({coverage: '#{coverage}', readonly: true});</script>)
      end
  end
end
