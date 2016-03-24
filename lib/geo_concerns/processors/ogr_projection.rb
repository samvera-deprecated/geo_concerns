require 'open-uri'

module GeoConcerns::Processors
  class OgrProjection < Hydra::Derivatives::Processors::Processor
    include Hydra::Derivatives::Processors::ShellBasedProcessor
    attr_reader :source_path, :directives

    def self.process(source_path, directives)
      new(source_path, directives).reproject # XXX: clean up after ourselves
    end

    def initialize(source_path, directives)
      @source_path = source_path
      @directives = directives

      @output_filename = output_file(File.extname(source_path).gsub(/^\./, ''))
      @output_directory = File.dirname(@output_filename)

      FileUtils.mkdir_p(@output_directory) unless File.directory?(@output_directory)
    end

    def reproject
      ogr2ogr
      normalize_prj_file
    end

    def prettywkt
      @srid ||= directives.fetch(:srid, 4326)
      @prettywkt ||= open("http://spatialreference.org/ref/epsg/#{@srid}/prettywkt/").read
    end

    # reproject via OGR, @see http://www.gdal.org/ogr2ogr.html
    # prevent recoding using SHAPE_ENCODING environment variable
    def ogr2ogr
      cmd = "env SHAPE_ENCODING= ogr2ogr -q -t_srs '#{prettywkt}' '#{@output_filename}' '#{source_path}'"
      self.class.execute(cmd)
    end

    # normalize prj file with the prettywkt
    def normalize_prj_file
      File.open(@output_filename.gsub(/\.shp$/, '.prj'), 'w') { |f| f.write(prettywkt) }
    end
  end
end
