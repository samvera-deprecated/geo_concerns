module GeoConcerns
  class ImageFormatService
    include GeoConcerns::AuthorityService
    self.authority = Qa::Authorities::Local.subauthority_for('image_formats')
  end
end
