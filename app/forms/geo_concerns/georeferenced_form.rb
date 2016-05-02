module GeoConcerns
  module GeoreferencedForm
    extend ActiveSupport::Concern

    included do
      self.terms += [:cartographic_projection]
    end
  end
end
