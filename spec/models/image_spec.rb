# Generated via
#  `rails generate curation_concerns:work Image`
require 'rails_helper'
require 'spec_helper'

describe Image do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  let(:image_file1) { ImageFile.new }
  let(:ext_metadata_file1 ) { ExternalMetadataFile.new}
  let(:ext_metadata_file2 ) { ExternalMetadataFile.new}
  let(:raster1 ) { Raster.new}
  let(:raster2 ) { Raster.new}

  it 'updates the title' do
    subject.attributes = { title: ['An image work'] }
    expect(subject.title).to eq(['An image work'])
  end

  describe 'metadata' do
    it 'has descriptive metadata' do
      expect(subject).to respond_to(:title)
    end
  end

  describe 'with acceptable inputs' do
    subject { described_class.new } 
    it 'add image,metadata,raster to file' do
      subject.members << image_file1
      subject.members << ext_metadata_file1
      subject.members << ext_metadata_file2
      subject.members << raster1
      subject.members << raster2
      expect(subject.image_files).to eq [image_file1]
      expect(subject.metadata_files).to eq [ext_metadata_file1,ext_metadata_file2]
      expect(subject.rasters).to eq [raster1,raster2]
    end
  end

  context 'georeferenced to a raster' do
    subject { FactoryGirl.create(:image_with_rasters, title: ['Test title 4'], georss_box: '17.881242 -179.14734 71.390482 179.778465') }

    it 'aggregates by raster resources' do
      expect(subject.rasters.size).to eq 2
      expect(subject.rasters.first).to be_kind_of Raster
    end
  end
end
