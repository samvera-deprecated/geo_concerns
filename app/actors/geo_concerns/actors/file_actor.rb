module GeoConcerns
  module Actors
    class FileActor < CurationConcerns::Actors::FileActor
      def ingest_file(file)
        working_file = copy_file_to_working_directory(file, file_set.id)
        IngestFileJob.perform_later(file_set,
                                    working_file,
                                    mime_type(file),
                                    user,
                                    relation)
        true
      end

      # Determines the correct mime type for a file. If the mime type is stored on
      # the file_set (set in the view), then use that value. If not, use the file
      # content type, if it exists.
      # @param [File, ActionDigest::HTTP::UploadedFile] file to get mime type from
      # @return [String] Mime type for the file
      def mime_type(file)
        return file_set.geo_mime_type if file_set.geo_mime_type
        file.respond_to?(:content_type) ? file.content_type : nil || file_set.geo_mime_type
      end
    end
  end
end
