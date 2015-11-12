# Generated via
#  `rails generate curation_concerns:work Image`

class CurationConcerns::ImageWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  set_curation_concern_type ImageWork
end
