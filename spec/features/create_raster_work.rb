require 'rails_helper'

RSpec.feature 'RasterWorkController', type: :feature do
  let(:user) { FactoryGirl.create(:admin) }
  let(:fgdc_file) { File.join(Rails.root, 'spec/fixtures/zipcodes_fgdc.xml') }

  context "an authorized user" do
    before do
      sign_in user
    end

    scenario "creating a raster work and attaching a vector work" do
      visit new_curation_concerns_raster_work_path
      expect(page).not_to have_text 'Add Your Content'
      fill_in 'raster_work_title', with: 'Raster Title'
      fill_in 'raster_work_temporal', with: '1989'
      choose 'visibility_open'
      select 'Attribution 3.0 United States', from: 'raster_work[rights]'
      click_button 'Create Raster work'

      expect(page).to have_text 'Raster Title'
      expect(page).to have_text '1989'
      expect(page).to have_text 'Open Access'
      expect(page).to have_link 'Attribution 3.0 United States', href: 'http://creativecommons.org/licenses/by/3.0/us/'

      click_link 'Attach a Vector Work'
      expect(page).not_to have_text 'Add Your Content'
      fill_in 'vector_work_title', with: 'Vector Title'
      fill_in 'vector_work_temporal', with: '1990'
      choose 'visibility_registered'
      select 'Attribution-ShareAlike 3.0 United States', from: 'vector_work[rights]'
      click_button 'Create Vector work'

      expect(page).to have_text 'Vector Title'
      expect(page).to have_text '1990'
      expect(page).to have_text 'Your Institution'
      expect(page).to have_link 'Attribution-ShareAlike 3.0 United States', href: 'http://creativecommons.org/licenses/by-sa/3.0/us/'

      click_link 'Attach a File'
      fill_in 'file_set[title][]', with: 'File Title'
      fill_in 'file_set_conforms_to', with: 'FGDC'
      attach_file 'file_set[files][]', fgdc_file
      click_button 'Attach to Vector Work'

      expect(page).to have_text 'zipcodes_fgdc.xml'
    end
  end
end
