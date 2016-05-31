module GeoConcerns
  module Ability
    extend ActiveSupport::Concern
    included do
      self.ability_logic += [:geo_concerns_permissions]
    end

    def geo_concerns_permissions
      alias_action :geoblacklight, to: :read
    end
  end
end
