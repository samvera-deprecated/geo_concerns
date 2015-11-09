# Generated via
#  `rails generate curation_concerns:work ImageFile`

class CurationConcerns::ImageFilesController < ApplicationController
  include CurationConcerns::CurationConcernController
  set_curation_concern_type ImageFile
end
