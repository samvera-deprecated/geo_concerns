class MetadataFormatService
  include AuthorityService
  self.authority = Qa::Authorities::Local.subauthority_for('metadata_formats')
end
