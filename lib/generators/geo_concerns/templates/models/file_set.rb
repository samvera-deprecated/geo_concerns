class FileSet < ActiveFedora::Base
  include ::CurationConcerns::FileSetBehavior
  include ::GeoConcerns::GeoFileSetBehavior
end
