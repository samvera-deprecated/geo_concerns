module GeoConcerns::Processors
  class ProjectData < Hydra::Derivatives::Processors::Processor
    def process
      code = directives.fetch(:format)
      case code
      when 'ESRI Shapefile'
        OgrProjection
      when 'GTiff'
        GdalProjection
      else
        fail NotImplementedError, "Unknown driver code: #{code}"
      end.process(source_path, directives)
    end
  end
end
