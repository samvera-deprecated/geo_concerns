FactoryGirl.define do
  factory :raster_file, class: FileSet do
    initialize_with { new({geo_file_format: 'TIFF_GeoTIFF'}) }
    transient do
      user { FactoryGirl.create(:user) }
      content nil

      cartographic_projection = 'urn:ogc:def:crs:EPSG::6326'
    end

    after(:build) do |file, evaluator|
      file.apply_depositor_metadata(evaluator.user.user_key)
    end

    after(:create) do |file, evaluator|
      if evaluator.content
        Hydra::Works::UploadFileToGenericFile.call(file, evaluator.content)
      end
    end

    factory :raster_file_with_raster do
      # after(:build) do |file, evaluator|
      #  file.title = ['testfile']
      # end
      after(:create) do |file, evaluator|
        if evaluator.content
          Hydra::Works::UploadFileToGenericFile.call(file, evaluator.content)
        end

        raster = FactoryGirl.create(:raster, user: evaluator.user)
        raster.raster_files << file
      end
    end
  end
end
