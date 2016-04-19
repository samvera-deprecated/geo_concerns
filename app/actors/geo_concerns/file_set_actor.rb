module GeoConcerns
  class FileSetActor < CurationConcerns::FileSetActor
    def file_actor_class
      GeoConcerns::FileActor
    end
  end
end
