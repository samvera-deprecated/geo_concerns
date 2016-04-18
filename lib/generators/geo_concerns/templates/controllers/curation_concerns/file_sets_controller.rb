module CurationConcerns
  class FileSetsController < ApplicationController
    include CurationConcerns::FileSetsControllerBehavior
    include GeoConcerns::FileSetsControllerBehavior
  end
end
