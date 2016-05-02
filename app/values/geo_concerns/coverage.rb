module GeoConcerns
  class Coverage
    class ParseError < StandardError; end
    class InvalidGeometryError < StandardError; end

    attr_reader :n, :e, :s, :w

    def self.parse_envelope(str)
      envelope_match = /ENVELOPE\(([\.\d\-]+), ([\.\d\-]+), ([\.\d\-]+), ([\.\d\-]+)\)/.match(str)
      raise ParseError, str if envelope_match.nil?
      n, e, s, w = envelope_match.captures.map { |capture| capture.to_f }
      new(n, e, s, w)
    end

    def self.parse(str)
      n = parse_coordinate(str, /northlimit=([\.\d\-]+);/)
      e = parse_coordinate(str, /eastlimit=([\.\d\-]+);/)
      s = parse_coordinate(str, /southlimit=([\.\d\-]+);/)
      w = parse_coordinate(str, /westlimit=([\.\d\-]+);/)
      raise ParseError, str if n.nil? || e.nil? || s.nil? || w.nil?
      new(n, e, s, w)
    end

    def self.parse_coordinate(str, regex)
      Regexp.last_match(1).to_f if str =~ regex
    end

    def initialize(n, e, s, w)
      raise InvalidGeometryError, "n=#{n} < s=#{s}" if n.to_f < s.to_f
      raise InvalidGeometryError, "e=#{e} < w=#{w}" if e.to_f < w.to_f
      @n = n
      @e = e
      @s = s
      @w = w
    end

    def to_s
      "northlimit=#{n}; eastlimit=#{e}; southlimit=#{s}; westlimit=#{w}; units=degrees; projection=EPSG:4326"
    end

    # Formats the coverage values into a Well-Known Text (WKT) Feature Envelope
    # @see http://www.opengeospatial.org/standards/sfa OpenGIS Implementation Specification for Geographic information - Simple feature access
    #
    # @return [String] the feature envelope
    def to_envelope
      "ENVELOPE(#{n}, #{e}, #{s}, #{w})"
    end
  end
end
