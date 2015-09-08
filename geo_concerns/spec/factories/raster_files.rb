FactoryGirl.define do
  factory :raster_file, class: RasterFile do
    transient do
      user { FactoryGirl.create(:user) }
      content nil
    end

    after(:build) do |file, evaluator|
      file.crs = 'urn:ogc:def:crs:EPSG::6326'
    end

    after(:create) do |file, evaluator|
      if evaluator.content
        Hydra::Works::UploadFileToGenericFile.call(file, evaluator.content)
      end
    end

    factory :raster_file_with_work do
      after(:build) do |file, evaluator|
        file.title = ['testfile']
      end
      after(:create) do |file, evaluator|
        if evaluator.content
          Hydra::Works::UploadFileToGenericFile.call(file, evaluator.content)
        end
        FactoryGirl.create(:raster, user: evaluator.user).raster_files << file
      end
    end
    after(:build) do |file, evaluator|
      file.apply_depositor_metadata(evaluator.user.user_key)
    end
  end
end
