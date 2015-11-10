# Generated via
#  `rails generate curation_concerns:work ExternalMetadataFile`

class CurationConcerns::ExternalMetadataFilesController < ApplicationController
  include CurationConcerns::CurationConcernController
  set_curation_concern_type ExternalMetadataFile
end
