CurationConcerns.configure do |config|
  # Injected via `rails g curation_concerns:work Vector`
  config.register_curation_concern :vector_work
  # Injected via `rails g curation_concerns:work Image`
  config.register_curation_concern :image_work
  # Injected via `rails g curation_concerns:work Raster`
  config.register_curation_concern :raster_work
end
