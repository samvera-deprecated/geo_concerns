FactoryGirl.define do
  factory :vector_work, aliases: [:private_vector_work], class: VectorWork do
    transient do
      user { FactoryGirl.create(:user) }

      visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end

    after(:build) do |vector_work, evaluator|
      vector_work.apply_depositor_metadata(evaluator.user.user_key)
    end

    factory :public_vector_work do
      before(:create) do |vector_work, evaluator|
        vector_work.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      end
    end

    factory :vector_work_with_one_file do
      before(:create) do |vector_work, evaluator|
        vector_work.ordered_members << FactoryGirl.create(:vector_file, user: evaluator.user, title:['A shapefile'], filename:'filename.zip')
      end
    end

    factory :vector_work_with_files do
      before(:create) do |vector_work, evaluator|
        2.times { vector_work.ordered_members << FactoryGirl.create(:vector_file, user: evaluator.user) }
      end
    end

    factory :vector_work_with_rasters do
      before(:create) do |vector_work, evaluator|
        2.times do
          raster = FactoryGirl.create(:raster, user: evaluator.user)
          raster.ordered_members << vector_work
        end
      end
    end

    factory :vector_work_with_metadata_files do
      after(:create) do |vector_work, evaluator|
        2.times { vector_work.ordered_members << FactoryGirl.create(:external_metadata_file, user: evaluator.user) }
      end
    end

    factory :vector_work_with_embargo_date do
      transient do
        embargo_date { Date.tomorrow.to_s }
      end

      factory :embargoed_vector_work do
        after(:build) { |vector_work, evaluator| vector_work.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
      end

      factory :embargoed_vector_work_with_files do
        after(:build) { |vector_work, evaluator| vector_work.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
        after(:create) { |vector_work, evaluator| 2.times { vector_work.ordered_members << FactoryGirl.create(:vector_file, user: evaluator.user) } }
      end

      factory :leased_vector_work do
        after(:build) { |vector_work, evaluator| vector_work.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
      end

      factory :leased_vector_work_with_files do
        after(:build) { |vector_work, evaluator| vector_work.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
        after(:create) { |vector_work, evaluator| 2.times { vector_work.ordered_members << FactoryGirl.create(:vector_file, user: evaluator.user) } }
      end
    end
  end
end
