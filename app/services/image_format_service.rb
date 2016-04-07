class ImageFormatService
  include AuthorityService
  self.authority = Qa::Authorities::Local.subauthority_for('image_formats')
end
