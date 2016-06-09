module GeoConcerns
  class EventsGenerator
    class CompositeGenerator
      attr_reader :generators

      def initialize(*generators)
        @generators = generators.compact
      end

      def method_missing(m, *args)
        generators.each do |generator|
          next unless generator.respond_to? m
          generator.send(m, args.first)
        end
      end
    end
  end
end
