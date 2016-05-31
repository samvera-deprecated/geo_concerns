module GeoConcerns
  class RasterFormatService
    include GeoConcerns::AuthorityService
    self.authority = Qa::Authorities::Local.subauthority_for('raster_formats')
  end
end
