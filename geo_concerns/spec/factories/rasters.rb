FactoryGirl.define do
  factory :raster, aliases: [:private_raster], class: Raster do
    transient do
      user { FactoryGirl.create(:user) }
    end

    title ["Test title"]
    georss_box '17.881242 -179.14734 71.390482 179.778465'
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE

    after(:build) do |raster, evaluator|
      raster.apply_depositor_metadata(evaluator.user.user_key)
    end

    factory :public_raster do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end

    factory :raster_with_one_file do
      before(:create) do |raster, evaluator|
        raster.generic_files << FactoryGirl.create(:generic_file, user: evaluator.user, title:['A Contained Generic File'], filename:['filename.pdf'])
      end
    end

    factory :raster_with_files do
      before(:create) { |raster, evaluator| 2.times { raster.generic_files << FactoryGirl.create(:generic_file, user: evaluator.user) } }
    end

    factory :with_embargo_date do
      transient do
        embargo_date { Date.tomorrow.to_s }
      end
      factory :embargoed_raster do
        after(:build) { |raster, evaluator| raster.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
      end

      factory :embargoed_raster_with_files do
        after(:build) { |raster, evaluator| raster.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
        after(:create) { |raster, evaluator| 2.times { raster.generic_files << FactoryGirl.create(:generic_file, user: evaluator.user) } }
      end

      factory :leased_raster do
        after(:build) { |raster, evaluator| raster.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
      end

      factory :leased_raster_with_files do
        after(:build) { |raster, evaluator| raster.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
        after(:create) { |raster, evaluator| 2.times { raster.generic_files << FactoryGirl.create(:generic_file, user: evaluator.user) } }
      end
    end
  end
end
