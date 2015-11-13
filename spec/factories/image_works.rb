FactoryGirl.define do
  factory :image_work, aliases: [:private_image_work], class: ImageWork do
    transient do
      user { FactoryGirl.create(:user) }

      visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end

    after(:build) do |image_work, evaluator|
      image_work.apply_depositor_metadata(evaluator.user.user_key)
    end

    factory :public_image_work do
      before(:create) do |image_work, evaluator|
        image_work.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      end
    end

    factory :image_work_with_one_file do
      before(:create) do |image_work, evaluator|
        image_work.ordered_members << FactoryGirl.create(:image_file, user: evaluator.user)
      end
    end

    factory :image_work_with_one_metadata_file do
      after(:create) do |image_work, evaluator|

        1.times { image_work.ordered_members << FactoryGirl.create(:external_metadata_file, user: evaluator.user) }
      end
    end

    factory :image_work_with_raster_works do
      before(:create) do |image_work, evaluator|
        2.times { image_work.ordered_members << FactoryGirl.create(:raster_work, user: evaluator.user) }
      end
    end

    factory :image_work_with_embargo_date do
      transient do
        embargo_date { Date.tomorrow.to_s }
      end

      factory :embargoed_image_work do
        after(:build) { |image_work, evaluator| image_work.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
      end

      factory :embargoed_image_work_with_files do
        after(:build) { |image_work, evaluator| image_work.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
        after(:create) { |image_work, evaluator| 2.times { image_work.image_files << FactoryGirl.create(:image_file, user: evaluator.user) } }
      end

      factory :leased_image_work do
        after(:build) { |image_work, evaluator| image_work.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
      end

      factory :leased_image_work_with_files do
        after(:build) { |image_work, evaluator| image_work.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
        after(:create) { |image_work, evaluator| 2.times { image_work.image_files << FactoryGirl.create(:image_file, user: evaluator.user) } }
      end
    end
  end
end
