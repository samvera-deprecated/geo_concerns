GeoConcerns::Engine.routes.draw do
  namespace :curation_concerns, path: :concern do
    resources :raster_works, only: [:new, :create], path: 'container/:parent_id/raster_works', as: 'member_raster_work'
    resources :vector_works, only: [:new, :create], path: 'container/:parent_id/vector_works', as: 'member_vector_work'
  end
end
