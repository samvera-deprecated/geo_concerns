# Generated via
#  `rails generate curation_concerns:work Vector`
require 'rails_helper'

describe VectorWork do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  let(:vector_file1) { FileSet.new(mime_type: 'application/zip; ogr-format="ESRI Shapefile"') }
  let(:vector_file2) { FileSet.new(mime_type: 'application/zip; ogr-format="ESRI Shapefile"') }
  let(:ext_metadata_file1) { FileSet.new(mime_type: 'application/xml; schema=iso19139') }
  let(:ext_metadata_file2) { FileSet.new(mime_type: 'application/xml; schema=iso19139') }
  let(:coverage) { GeoConcerns::Coverage.new(43.039, -69.856, 42.943, -71.032) }

  describe 'with acceptable inputs' do
    subject { described_class.new }
    it 'add vectorfile,metadatato file' do
      subject.members << vector_file1
      subject.members << vector_file2
      subject.members << ext_metadata_file1
      subject.members << ext_metadata_file2
      expect(subject.vector_files).to eq [vector_file1, vector_file2]
      expect(subject.metadata_files).to eq [ext_metadata_file1, ext_metadata_file2]
    end
  end

  it 'updates the title' do
    subject.attributes = { title: ['A vector work'] }
    expect(subject.title).to eq(['A vector work'])
  end

  it 'updates the coverage' do
    subject.attributes = { coverage: coverage.to_s }
    expect(subject.coverage).to eq(coverage.to_s)
  end

  describe 'metadata' do
    it 'has descriptive metadata' do
      expect(subject).to respond_to(:title)
    end

    it 'has geospatial metadata' do
      expect(subject).to respond_to(:coverage)
    end
  end

  context 'with files' do
    subject { FactoryGirl.create(:vector_work_with_files, title: ['Test title 4'], coverage: coverage.to_s) }

    it 'has two files' do
      expect(subject.vector_files.size).to eq 2
      expect(subject.vector_files.first.mime_type).to eq 'application/zip; ogr-format="ESRI Shapefile"'
    end
  end

  context 'with metadata files' do
    subject { FactoryGirl.create(:vector_work_with_metadata_files) }

    it 'aggregates external metadata files' do
      expect(subject.metadata_files.size).to eq 2
      expect(subject.metadata_files.first.mime_type).to eq 'application/xml; schema=iso19139'
    end
  end

  describe "to_solr" do
    subject { FactoryGirl.build(:vector_work, date_uploaded: Time.zone.today, coverage: coverage.to_s).to_solr }
    it "indexes ordered_by_ssim field" do
      expect(subject.keys).to include 'ordered_by_ssim'
    end
  end

  describe 'populate_metadata' do
    subject { FactoryGirl.create(:vector_work_with_one_metadata_file) }
    let(:doc) { Nokogiri::XML(read_test_data_fixture('McKay/S_566_1914_clip_iso.xml')) }

    it 'has an extraction method' do
      expect(subject).to respond_to(:extract_metadata)
    end

    it 'can perform extraction and set for ISO 19139' do
      external_metadata_file = subject.metadata_files.first
      allow(external_metadata_file).to receive(:metadata_xml) { doc }
      allow(external_metadata_file).to receive(:mime_type) { 'application/xml; schema=iso19139' }
      subject.populate_metadata
      expect(subject.title).to eq(['S_566_1914_clip.tif'])
    end

    it 'will fail if there are multiple metadata files' do
      expect { FactoryGirl.create(:vector_work_with_metadata_files).extract_metadata }.to raise_error(NotImplementedError)
    end
  end
end
