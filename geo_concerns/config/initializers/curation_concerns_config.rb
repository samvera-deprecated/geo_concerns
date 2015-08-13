CurationConcerns.configure do |config|
  # Injected via `rails g curation_concerns:work FeatureExtraction`
  config.register_curation_concern :feature_extraction
  # Injected via `rails g curation_concerns:work Vector`
  config.register_curation_concern :vector
  # Injected via `rails g curation_concerns:work Image`
  config.register_curation_concern :image
  # Injected via `rails g curation_concerns:work Raster`
  config.register_curation_concern :raster
end
