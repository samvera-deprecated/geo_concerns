require 'open-uri'

module GeoConcerns::Processors
  class GdalProjection < Hydra::Derivatives::Processors::Processor
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

      @srid ||= directives.fetch(:srid, 4326)

      FileUtils.mkdir_p(@output_directory) unless File.directory?(@output_directory)
    end

    def reproject
      gdalwarp
    end

    # reproject via GDAL, @see http://www.gdal.org/gdalwarp.html
    def gdalwarp(resample = 'bilinear')
      tempfn = File.join(@output_directory, File.basename(source_path))
      # reproject with gdalwarp (must uncompress here to prevent bloat)
      self.class.execute "gdalwarp -q -r #{resample} -t_srs EPSG:#{@srid} #{source_path} #{tempfn} -co 'COMPRESS=NONE'"
      fail "gdalwarp failed to create #{tempfn}" unless File.size?(tempfn)

      # compress tempfn with gdal_translate
      self.class.execute "gdal_translate -q -a_srs EPSG:#{@srid} #{tempfn} #{@output_filename} -co 'COMPRESS=LZW'"
      fail "gdal_translate failed to create #{@output_filename}" unless File.size?(@output_filename)
    ensure
      FileUtils.rm_f(tempfn)
    end
  end
end
