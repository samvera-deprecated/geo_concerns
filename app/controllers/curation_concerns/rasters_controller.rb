# Generated via
#  `rails generate curation_concerns:work Raster`

class CurationConcerns::RastersController < ApplicationController
  include CurationConcerns::CurationConcernController
  set_curation_concern_type RasterWork
end
