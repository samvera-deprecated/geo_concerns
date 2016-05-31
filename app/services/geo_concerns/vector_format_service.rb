module GeoConcerns
  class VectorFormatService
    include GeoConcerns::AuthorityService
    self.authority = Qa::Authorities::Local.subauthority_for('vector_formats')
  end
end
