FactoryGirl.define do
  factory :raster, aliases: [:private_raster], class: Raster do
    transient do
      user { FactoryGirl.create(:user) }

      title = ["Test title"]
      georss_box = '17.881242 -179.14734 71.390482 179.778465'
      visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end

    after(:build) do |raster, evaluator|
      raster.apply_depositor_metadata(evaluator.user.user_key)

      raster.title = ["Test title"]
      raster.georss_box = '17.881242 -179.14734 71.390482 179.778465'
      raster.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end

    factory :public_raster do
      before(:create) do |raster, evaluator|
        raster.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      end
    end

    factory :raster_with_one_file do

      before(:create) do |raster, evaluator|
        raster.title = ["Test title"]
        raster.georss_box = '17.881242 -179.14734 71.390482 179.778465'
        raster.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE

        raster.raster_files << FactoryGirl.create(:raster_file, user: evaluator.user, title:['A Contained Raster File'], filename:['filename.pdf'])
      end
    end

    factory :raster_with_files do

      before(:create) do |raster, evaluator|
        raster.title = ["A raster with two raster files"]
        raster.georss_box = '17.881242 -179.14734 71.390482 179.778465'
        raster.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE

        2.times { raster.raster_files << FactoryGirl.create(:raster_file, user: evaluator.user) }
      end
    end

    factory :raster_with_images do
      before(:create) do |raster, evaluator|
        raster.title = ["A raster with two raster files"]
        raster.georss_box = '17.881242 -179.14734 71.390482 179.778465'
        raster.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE

        image = FactoryGirl.create(:image, user: evaluator.user)
        image.rasters << raster
      end
    end

    factory :raster_with_vectors do

      after(:create) do |raster, evaluator|
        raster.title = ["A raster with two vectors"]
        raster.georss_box = '17.881242 -179.14734 71.390482 179.778465'
        raster.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE

        2.times { raster.vectors << FactoryGirl.create(:vector, user: evaluator.user) }
      end
    end

    factory :raster_with_metadata_files do

      after(:create) do |raster, evaluator|
        raster.title = ["A raster with two vectors"]
        raster.georss_box = '17.881242 -179.14734 71.390482 179.778465'
        raster.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE

        2.times { raster.metadata_files << FactoryGirl.create(:raster_metadata_file, user: evaluator.user) }
      end
    end

    factory :raster_with_embargo_date do
      transient do
        embargo_date { Date.tomorrow.to_s }
      end
      factory :embargoed_raster do
        after(:build) { |raster, evaluator| raster.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
      end

      factory :embargoed_raster_with_files do
        after(:build) { |raster, evaluator| raster.apply_embargo(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
        after(:create) { |raster, evaluator| 2.times { raster.raster_files << FactoryGirl.create(:raster_file, user: evaluator.user) } }
      end

      factory :leased_raster do
        after(:build) { |raster, evaluator| raster.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
      end

      factory :leased_raster_with_files do
        after(:build) { |raster, evaluator| raster.apply_lease(evaluator.embargo_date, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
        after(:create) { |raster, evaluator| 2.times { raster.raster_files << FactoryGirl.create(:raster_file, user: evaluator.user) } }
      end
    end
  end
end
