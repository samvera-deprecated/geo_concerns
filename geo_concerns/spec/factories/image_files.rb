FactoryGirl.define do
  factory :image_file, class: ImageFile do
    transient do
      title = ['Test Image File']
      user { FactoryGirl.create(:user) }
      content nil
    end

    after(:build) do |file, evaluator|
      file.title = ['testfile']
    end

    after(:create) do |file, evaluator|
      if evaluator.content
        Hydra::Works::UploadFileToGenericFile.call(file, evaluator.content)
      end
    end

    factory :image_file_with_work do
      after(:build) do |file, evaluator|
        file.title = ['testfile']
      end
      after(:create) do |file, evaluator|
        if evaluator.content
          Hydra::Works::UploadFileToGenericFile.call(file, evaluator.content)
        end
        FactoryGirl.create(:image, user: evaluator.user).image_files << file
      end
    end
    after(:build) do |file, evaluator|
      file.apply_depositor_metadata(evaluator.user.user_key)
    end
  end
end
