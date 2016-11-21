module CurationConcerns
  class FileSetsController < ApplicationController
    include CurationConcerns::FileSetsControllerBehavior
    include GeoConcerns::FileSetsControllerBehavior
    include GeoConcerns::MessengerBehavior
  end
end
