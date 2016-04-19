module AuthorityService
  extend ActiveSupport::Concern

  included do
    mattr_accessor :authority
  end

  class_methods do
    def select_options
      authority.all.map do |element|
        [element[:label], element[:id]]
      end
    end

    def label(id)
      (authority.find(id) || {}).fetch('term', nil)
    end

    def include?(id)
      !authority.find(id).nil? && !authority.find(id).empty?
    end
  end
end
