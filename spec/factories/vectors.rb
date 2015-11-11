FactoryGirl.define do
  factory :vector, aliases: [:private_vector], class: Vector do
    transient do
      user { FactoryGirl.create(:user) }

      visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end

    after(:build) do |vector, evaluator|
      vector.apply_depositor_metadata(evaluator.user.user_key)
    end

    factory :public_vector do
      before(:create) do |vector, evaluator|
        vector.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      end
    end

    factory :vector_with_one_file do
      before(:create) do |vector, evaluator|
        vector.vector_files << FactoryGirl.create(:vector_file, user: evaluator.user, title:['A shapefile'], filename:'filename.zip')
      end
    end

    factory :vector_with_files do
      before(:create) do |vector, evaluator|
        2.times { vector.vector_files << FactoryGirl.create(:vector_file, user: evaluator.user) }
      end
    end

    factory :vector_with_rasters do
      before(:create) do |vector, evaluator|
        2.times do
          raster = FactoryGirl.create(:raster, user: evaluator.user)
          raster.vectors << vector
        end
      end
    end

    factory :vector_with_metadata_files do
      after(:create) do |vector, evaluator|
        2.times { vector.metadata_files << FactoryGirl.create(:external_metadata_file, user: evaluator.user) }
      end
    end

    factory :vector_with_embargo_date do
      transient do
        embargo_date { Date.tomorrow.to_s }
      end

      factory :embargoed_vector do
        after(:build) { |vector, evaluator| vector.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
      end

      factory :embargoed_vector_with_files do
        after(:build) { |vector, evaluator| vector.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
        after(:create) { |vector, evaluator| 2.times { vector.vector_files << FactoryGirl.create(:vector_file, user: evaluator.user) } }
      end

      factory :leased_vector do
        after(:build) { |vector, evaluator| vector.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
      end

      factory :leased_vector_with_files do
        after(:build) { |vector, evaluator| vector.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
        after(:create) { |vector, evaluator| 2.times { vector.vector_files << FactoryGirl.create(:vector_file, user: evaluator.user) } }
      end
    end
  end
end
