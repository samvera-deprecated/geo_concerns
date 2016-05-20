FactoryGirl.define do
  factory :raster_work, aliases: [:private_raster_work], class: RasterWork do
    transient do
      user { FactoryGirl.create(:user) }

      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end

    after(:build) do |raster_work, evaluator|
      raster_work.apply_depositor_metadata(evaluator.user.user_key)
    end

    factory :public_raster_work do
      before(:create) do |raster_work, _evaluator|
        raster_work.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      end
    end

    factory :raster_work_with_one_file do
      before(:create) do |raster_work, evaluator|
        raster_work.ordered_members << FactoryGirl.create(:raster_file, user: evaluator.user, title: ['A GeoTIFF file'])
      end
    end

    factory :raster_work_with_files do
      before(:create) do |raster_work, evaluator|
        2.times { raster_work.ordered_members << FactoryGirl.create(:raster_file, user: evaluator.user) }
      end
    end

    factory :raster_work_with_image_works do
      before(:create) do |raster_work, evaluator|
        image = FactoryGirl.create(:image_work, user: evaluator.user)
        image.ordered_members << raster_work
      end
    end

    factory :raster_work_with_vector_work do
      after(:create) do |raster_work, evaluator|
        raster_work.ordered_members << FactoryGirl.create(:vector_work, user: evaluator.user)
        raster_work.save
      end
    end

    factory :raster_work_with_one_metadata_file do
      after(:create) do |raster_work, evaluator|
        1.times { raster_work.ordered_members << FactoryGirl.create(:external_metadata_file, user: evaluator.user) }
      end
    end

    factory :raster_work_with_metadata_files do
      after(:create) do |raster_work, evaluator|
        2.times { raster_work.ordered_members << FactoryGirl.create(:external_metadata_file, user: evaluator.user) }
      end
    end

    factory :raster_work_with_files_and_metadata_files do
      after(:create) do |raster_work, evaluator|
        raster_work.ordered_members << FactoryGirl.create(:raster_file, user: evaluator.user)
        raster_work.ordered_members << FactoryGirl.create(:external_metadata_file, user: evaluator.user)
        raster_work.save
      end
    end

    factory :raster_work_with_embargo_date do
      transient do
        embargo_date { Date.tomorrow.to_s }
      end
      factory :embargoed_raster_work do
        after(:build) { |raster_work, evaluator| raster_work.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
      end

      factory :embargoed_raster_work_with_files do
        after(:build) { |raster_work, evaluator| raster_work.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
        after(:create) { |raster_work, evaluator| 2.times { raster_work.ordered_members << FactoryGirl.create(:raster_file, user: evaluator.user) } }
      end

      factory :leased_raster_work do
        after(:build) { |raster_work, evaluator| raster_work.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
      end

      factory :leased_raster_work_with_files do
        after(:build) { |raster_work, evaluator| raster_work.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
        after(:create) { |raster_work, evaluator| 2.times { raster_work.ordered_members << FactoryGirl.create(:raster_file, user: evaluator.user) } }
      end
    end
  end
end
