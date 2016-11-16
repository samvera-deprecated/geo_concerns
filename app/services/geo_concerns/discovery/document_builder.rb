module GeoConcerns
  module Discovery
    class DocumentBuilder
      attr_reader :geo_concern, :document
      delegate :to_json, :to_xml, :to_hash, to: :document

      def initialize(geo_concern, document)
        @geo_concern = geo_concern
        @document = document
        builders.build(document)
      end

      # Returns a document path object. Used to get urls for links in the document.
      # @return [DocumentPath] geoblacklight document as a json string
      def root_path
        @root_path ||= DocumentPath.new(geo_concern)
      end

      # Instantiates a CompositeBuilder object with an array of
      # builder instances that are used to create the document.
      # @return [CompositeBuilder] composite builder for document
      def builders
        @builders ||= CompositeBuilder.new(
          basic_metadata_builder,
          spatial_builder,
          date_builder,
          references_builder,
          layer_info_builder
        )
      end

      # Instantiates a BasicMetadataBuilder object.
      # Builds fields such as id, subject, and publisher.
      # @return [BasicMetadataBuilder] basic metadata builder for document
      def basic_metadata_builder
        BasicMetadataBuilder.new(geo_concern)
      end

      # Instantiates a SpatialBuilder object.
      # Builds spatial fields such as bounding box and solr geometry.
      # @return [SpatialBuilder] spatial builder for document
      def spatial_builder
        SpatialBuilder.new(geo_concern)
      end

      # Instantiates a DateBuilder object.
      # Builds date fields such as layer year and modified date.
      # @return [DateBuilder] date builder for document
      def date_builder
        DateBuilder.new(geo_concern)
      end

      # Instantiates a ReferencesBuilder object.
      # Builds service reference fields such as thumbnail and download url.
      # @return [ReferencesBuilder] references builder for document
      def references_builder
        ReferencesBuilder.new(geo_concern, root_path)
      end

      # Instantiates a LayerInfoBuilder object.
      # Builds fields about the geospatial file such as geometry and format.
      # @return [LayerInfoBuilder] layer info builder for document
      def layer_info_builder
        LayerInfoBuilder.new(geo_concern)
      end
    end
  end
end
