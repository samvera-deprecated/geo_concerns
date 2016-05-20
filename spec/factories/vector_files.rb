FactoryGirl.define do
  factory :vector_file, class: FileSet do
    initialize_with { new(geo_mime_type: 'application/zip; ogr-format="ESRI Shapefile"') }
    transient do
      user { FactoryGirl.create(:user) }
      content nil
    end

    after(:build) do |file, evaluator|
      file.apply_depositor_metadata(evaluator.user.user_key)
    end

    after(:create) do |file, evaluator|
      if evaluator.content
        Hydra::Works::UploadFileToFileSet.call(file, evaluator.content)
      end
    end

    factory :vector_file_with_vector do
      after(:build) do |file, _evaluator|
        file.title = ['testfile']
      end
      after(:create) do |file, evaluator|
        if evaluator.content
          Hydra::Works::UploadFileToFileSet.call(file, evaluator.content)
        end
        FactoryGirl.create(:vector, user: evaluator.user).vector_files << file
      end
    end
  end
end
