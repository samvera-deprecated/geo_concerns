# Generated via
#  `rails generate curation_concerns:work Vector`
require 'rails_helper'

describe VectorWork do
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
    subject.attributes = { bounding_box: '17.881242 -179.14734 71.390482 179.778465' }
    expect(subject.bounding_box).to eq('17.881242 -179.14734 71.390482 179.778465')
  end

  describe 'metadata' do
    it 'has descriptive metadata' do
      expect(subject).to respond_to(:title)
    end

    it 'has geospatial metadata' do
      expect(subject).to respond_to(:bounding_box)
    end
  end

  context 'with files' do
    subject { FactoryGirl.create(:vector_work_with_files, title: ['Test title 4'], bounding_box: '17.881242 -179.14734 71.390482 179.778465') }

    it 'has two files' do
      expect(subject.vector_files.size).to eq 2
      expect(subject.vector_files.first).to be_kind_of VectorFile
    end
  end

  context 'with metadata files' do
    subject { FactoryGirl.create(:vector_work_with_metadata_files) }

    it 'aggregates external metadata files' do
      expect(subject.metadata_files.size).to eq 2
      expect(subject.metadata_files.first).to be_kind_of ExternalMetadataFile
    end
  end

  describe "to_solr" do
    subject { FactoryGirl.build(:vector_work, date_uploaded: Date.today, bounding_box: '17.881242 -179.14734 71.390482 179.778465').to_solr }
    it "indexes bbox field" do
      expect(subject.keys).to include 'bounding_box_tesim'
    end
  end

  describe 'extract_metadata' do
    subject { FactoryGirl.create(:vector_work_with_one_metadata_file) }

    it 'has an extraction method' do
      expect(subject).to respond_to(:extract_metadata)
    end

    it 'can perform extraction for ISO 19139' do
      doc = Nokogiri::XML(read_test_data_fixture('McKay/S_566_1914_clip_iso.xml'))
      externalMetadataFile = subject.metadata_files.first
      expect(externalMetadataFile.conforms_to.downcase).to eq('iso19139')
      allow(externalMetadataFile).to receive(:metadata_xml) { doc }
      subject.extract_metadata
      expect(subject.title).to eq(['S_566_1914_clip.tif'])
    end

    it 'will fail if there are multiple metadata files' do
      expect { FactoryGirl.create(:vector_work_with_metadata_files).extract_metadata }.to raise_error(NotImplementedError)
    end
  end
end
