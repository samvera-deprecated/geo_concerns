# Generated via
#  `rails generate curation_concerns:work VectorWork`

class CurationConcerns::VectorWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  set_curation_concern_type VectorWork
end
