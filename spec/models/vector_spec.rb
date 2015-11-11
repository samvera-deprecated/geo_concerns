# Generated via
#  `rails generate curation_concerns:work Vector`
require 'rails_helper'

describe Vector do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  let(:vector_file1) { VectorFile.new }
  let(:vector_file2) { VectorFile.new }
  let(:ext_metadata_file1 ) { ExternalMetadataFile.new}
  let(:ext_metadata_file2 ) { ExternalMetadataFile.new}

  describe 'with acceptable inputs' do
    subject { described_class.new } 
    it 'add vectorfile,metadatato file' do
      subject.members << vector_file1
      subject.members << vector_file2
      subject.members << ext_metadata_file1
      subject.members << ext_metadata_file2
      expect(subject.vector_files).to eq [vector_file1,vector_file2]
      expect(subject.metadata_files).to eq [ext_metadata_file1,ext_metadata_file2]
    end
  end

  it 'updates the title' do
    subject.attributes = { title: ['A vector work'] }
    expect(subject.title).to eq(['A vector work'])
  end

  it 'updates the bounding box' do
    subject.attributes = { georss_box: '17.881242 -179.14734 71.390482 179.778465' }
    expect(subject.georss_box).to eq('17.881242 -179.14734 71.390482 179.778465')
  end

  describe 'metadata' do
    it 'has descriptive metadata' do
      expect(subject).to respond_to(:title)
    end

    it 'has geospatial metadata' do
      expect(subject).to respond_to(:georss_box)
    end
  end

  context 'with files' do
    subject { FactoryGirl.create(:vector_with_files, title: ['Test title 4'], georss_box: '17.881242 -179.14734 71.390482 179.778465') }

    it 'has two files' do
      expect(subject.vector_files.size).to eq 2
      expect(subject.vector_files.first).to be_kind_of VectorFile
    end
  end

  context 'extracting features from rasters' do
    subject { FactoryGirl.create(:vector_with_rasters) }

    it 'is aggregated by two raster data set resources' do
      expect(subject.rasters.size).to eq 2
      expect(subject.rasters.first).to be_kind_of Raster
    end
  end

  context 'with metadata files' do
    subject { FactoryGirl.create(:vector_with_metadata_files) }

    it 'aggregates external metadata files' do
      expect(subject.metadata_files.size).to eq 2
      expect(subject.metadata_files.first).to be_kind_of ExternalMetadataFile
    end
  end

  describe "to_solr" do
    subject { FactoryGirl.build(:vector, date_uploaded: Date.today, georss_box: '17.881242 -179.14734 71.390482 179.778465').to_solr }
    it "indexes bbox field" do
      expect(subject.keys).to include 'georss_box_tesim'
    end
  end
end
