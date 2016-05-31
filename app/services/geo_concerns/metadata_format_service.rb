module GeoConcerns
  class MetadataFormatService
    include GeoConcerns::AuthorityService
    self.authority = Qa::Authorities::Local.subauthority_for('metadata_formats')
  end
end
