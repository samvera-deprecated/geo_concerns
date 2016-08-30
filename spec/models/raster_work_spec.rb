require 'spec_helper'

describe RasterWork do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  let(:raster_file1) { FileSet.new(geo_mime_type: 'image/tiff; gdal-format=GTiff') }
  let(:raster_file2) { FileSet.new(geo_mime_type: 'image/tiff; gdal-format=GTiff') }
  let(:ext_metadata_file1) { FileSet.new(geo_mime_type: 'application/xml; schema=iso19139') }
  let(:ext_metadata_file2) { FileSet.new(geo_mime_type: 'application/xml; schema=iso19139') }
  let(:vector1) { VectorWork.new }
  let(:vector2) { VectorWork.new }
  let(:coverage) { GeoConcerns::Coverage.new(43.039, -69.856, 42.943, -71.032) }

  it 'updates the title' do
    subject.attributes = { title: ['A raster work'] }
    expect(subject.title).to eq(['A raster work'])
  end

  it 'updates the bounding box' do
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

  describe 'with acceptable inputs' do
    subject { described_class.new }
    it 'adds raster file set, metadata file set, vector work to file' do
      subject.members << raster_file1
      subject.members << raster_file2
      subject.members << ext_metadata_file1
      subject.members << ext_metadata_file2
      subject.members << vector1
      subject.members << vector2
      expect(subject.raster_files).to match_array [raster_file1, raster_file2]
      expect(subject.metadata_files).to match_array [ext_metadata_file1, ext_metadata_file2]
      expect(subject.vector_works).to match_array [vector1, vector2]
    end
    it 'defines what type of object it is' do
      expect(subject.raster_work?).to be_truthy
      expect(subject.raster_file?).to be_falsey
      expect(subject.image_work?).to be_falsey
      expect(subject.image_file?).to be_falsey
      expect(subject.vector_work?).to be_falsey
      expect(subject.vector_file?).to be_falsey
      expect(subject.external_metadata_file?).to be_falsey
    end
  end

  context 'with raster files' do
    subject { FactoryGirl.create(:raster_work_with_files, title: ['Test title 4'], coverage: coverage.to_s) }

    it 'has two files' do
      expect(subject.raster_files.size).to eq 2
      expect(subject.raster_files.first.geo_mime_type).to eq 'image/tiff; gdal-format=GTiff'
    end
  end

  context 'with vector feature extractions' do
    subject { FactoryGirl.create(:raster_work_with_vector_work) }

    it 'aggregates vector data set resources' do
      expect(subject.vector_works.size).to eq 1
      expect(subject.vector_works.first).to be_kind_of VectorWork
    end
  end

  context 'with metadata files' do
    subject { FactoryGirl.create(:raster_work_with_metadata_files) }

    it 'aggregates external metadata files' do
      expect(subject.metadata_files.size).to eq 2
      expect(subject.metadata_files.first.geo_mime_type).to eq 'application/xml; schema=iso19139'
    end
  end

  describe '#image_work' do
    let(:raster_work) { FactoryGirl.create(:raster_work, title: ['Raster'], coverage: coverage.to_s) }
    let(:image_work) { FactoryGirl.create(:image_work, title: ['Image'], coverage: coverage.to_s) }

    before do
      image_work.ordered_members << raster_work
      raster_work.save
      image_work.save
    end

    it 'has a parent image work' do
      expect(raster_work.image_work).to be_a ImageWork
    end
  end

  describe "to_solr" do
    subject { FactoryGirl.build(:raster_work, date_uploaded: Time.zone.today, coverage: coverage.to_s).to_solr }
    it "indexes ordered_by_ssim field" do
      expect(subject.keys).to include 'ordered_by_ssim'
    end
  end

  describe 'populate_metadata' do
    subject { FactoryGirl.create(:raster_work_with_one_metadata_file) }
    let(:doc) { Nokogiri::XML(read_test_data_fixture('McKay/S_566_1914_clip_iso.xml')) }

    it 'has an extraction method' do
      expect(subject).to respond_to(:extract_metadata)
    end

    it 'can perform extraction and set properties for ISO 19139' do
      external_metadata_file = subject.metadata_files.first
      allow(external_metadata_file).to receive(:metadata_xml).and_return(doc)
      allow(external_metadata_file).to receive(:geo_mime_type).and_return('application/xml; schema=iso19139')
      subject.should_populate_metadata = 'true'
      expect(subject.title).to eq(['S_566_1914_clip.tif'])
    end
  end
end
