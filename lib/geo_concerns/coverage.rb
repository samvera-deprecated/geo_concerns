module GeoConcerns
  class Coverage
    class ParseError < StandardError; end
    class InvalidGeometryError < StandardError; end

    attr_reader :n, :e, :s, :w

    # rubocop:disable Style/PerlBackrefs, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def self.parse(str)
      n = $1.to_f if str =~ /northlimit=([\.\d\-]+);/
      e = $1.to_f if str =~ /eastlimit=([\.\d\-]+);/
      s = $1.to_f if str =~ /southlimit=([\.\d\-]+);/
      w = $1.to_f if str =~ /westlimit=([\.\d\-]+);/
      fail ParseError, str if n.nil? || e.nil? || s.nil? || w.nil?
      new(n, e, s, w)
    rescue
      fail ParseError, str
    end
    # rubocop:enable Style/PerlBackrefs, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    def initialize(n, e, s, w)
      fail InvalidGeometryError, "n=#{n} < s=#{s}" if n.to_f < s.to_f
      fail InvalidGeometryError, "e=#{e} < w=#{w}" if e.to_f < w.to_f
      @n = n
      @e = e
      @s = s
      @w = w
    end

    def to_s
      "northlimit=#{n}; eastlimit=#{e}; southlimit=#{s}; westlimit=#{w}; units=degrees; projection=EPSG:4326"
    end
  end
end
