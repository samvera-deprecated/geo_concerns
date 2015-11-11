FactoryGirl.define do
  factory :image, aliases: [:private_image], class: Image do
    transient do
      user { FactoryGirl.create(:user) }

      visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end

    after(:build) do |image, evaluator|
      image.apply_depositor_metadata(evaluator.user.user_key)
    end

    factory :public_image do
      before(:create) do |image, evaluator|
        image.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      end
    end

    factory :image_with_one_file do
      before(:create) do |image, evaluator|
        image.image_file << FactoryGirl.create(:image_file, user: evaluator.user)
      end
    end

    factory :image_with_rasters do
      before(:create) do |image, evaluator|
        2.times { image.rasters << FactoryGirl.create(:raster, user: evaluator.user) }
      end
    end

    factory :image_with_embargo_date do
      transient do
        embargo_date { Date.tomorrow.to_s }
      end

      factory :embargoed_image do
        after(:build) { |image, evaluator| image.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
      end

      factory :embargoed_image_with_files do
        after(:build) { |image, evaluator| image.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
        after(:create) { |image, evaluator| 2.times { image.image_files << FactoryGirl.create(:image_file, user: evaluator.user) } }
      end

      factory :leased_image do
        after(:build) { |image, evaluator| image.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
      end

      factory :leased_image_with_files do
        after(:build) { |image, evaluator| image.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
        after(:create) { |image, evaluator| 2.times { image.image_files << FactoryGirl.create(:image_file, user: evaluator.user) } }
      end
    end
  end
end
