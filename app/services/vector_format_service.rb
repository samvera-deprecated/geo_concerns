class VectorFormatService
  include AuthorityService
  self.authority = Qa::Authorities::Local.subauthority_for('vector_formats')
end
