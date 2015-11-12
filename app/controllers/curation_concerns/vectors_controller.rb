# Generated via
#  `rails generate curation_concerns:work Vector`

class CurationConcerns::VectorsController < ApplicationController
  include CurationConcerns::CurationConcernController
  set_curation_concern_type VectorWork
end
