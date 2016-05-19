module GeoConcerns
  module Actors
    class FileSetActor < CurationConcerns::Actors::FileSetActor
      def file_actor_class
        ::GeoConcerns::Actors::FileActor
      end
    end
  end
end
