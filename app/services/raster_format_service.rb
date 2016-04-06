class RasterFormatService
  include AuthorityService
  self.authority = Qa::Authorities::Local.subauthority_for('raster_formats')
end
