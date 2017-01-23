module GeoConcerns
  module GeoServer
    def config
      @config ||= config_yaml.with_indifferent_access
    end

    private

      def config_yaml
        file = File.join(GeoConcerns.root, 'config', 'geoserver.yml')
        file = File.join(Rails.root, 'config', 'geoserver.yml') unless File.exist? file
        YAML.load(ERB.new(File.read(file)).result)['geoserver']
      end

      module_function :config, :config_yaml
  end
end
