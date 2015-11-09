require 'spec_helper'

# This tests the Raster model. It includes the RasterBehavior module and nothing else.
# So this test covers both the RasterBehavior module and the Raster model
describe Raster do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  let(:raster_file1) { RasterFile.new }
  let(:raster_file2) { RasterFile.new }
  let(:ext_metadata_file1 ) { ExternalMetadataFile.new}
  let(:ext_metadata_file2 ) { ExternalMetadataFile.new}
  let(:vector1 ) { Vector.new}
  let(:vector2 ) { Vector.new}

  it 'updates the title' do
    subject.attributes = { title: ['A raster work'] }
    expect(subject.title).to eq(['A raster work'])
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

  describe 'with acceptable inputs' do
    subject { described_class.new } 
    it 'add rasterfile,metadata,vector to file' do
      subject.members << raster_file1
      subject.members << raster_file2
      subject.members << ext_metadata_file1
      subject.members << ext_metadata_file2
      subject.members << vector1
      subject.members << vector2
      expect(subject.raster_files).to eq [raster_file1,raster_file2]
      expect(subject.metadata_files).to eq [ext_metadata_file1,ext_metadata_file2]
      expect(subject.vectors).to eq [vector1,vector2]
    end
  end

  context 'with raster files' do
    subject { FactoryGirl.create(:raster_with_files, title: ['Test title 4'], georss_box: '17.881242 -179.14734 71.390482 179.778465') }

    it 'has two files' do
      expect(subject.raster_files.size).to eq 2
      expect(subject.raster_files.first).to be_kind_of RasterFile
    end
  end

  context 'georeferenced from an image' do
    subject { FactoryGirl.create(:raster_with_images, title: ['Test title 4'], georss_box: '17.881242 -179.14734 71.390482 179.778465') }

    it 'is aggregated by an image resource' do
      expect(subject.images.size).to eq 1
      expect(subject.images.first).to be_kind_of Image

      expect(subject.image).to be_kind_of Image
    end
  end

  context 'with vector feature extractions' do
    subject { FactoryGirl.create(:raster_with_vectors) }

    it 'aggregates vector data set resources' do
      expect(subject.vectors.size).to eq 2
      expect(subject.vectors.first).to be_kind_of Vector
    end
  end

  context 'with metadata files' do
    subject { FactoryGirl.create(:raster_with_metadata_files) }

    it 'aggregates external metadata files' do
      expect(subject.metadata_files.size).to eq 2
      expect(subject.metadata_files.first).to be_kind_of ExternalMetadataFile
    end
  end

  describe "to_solr" do
    subject { FactoryGirl.build(:raster, date_uploaded: Date.today, georss_box: '17.881242 -179.14734 71.390482 179.778465').to_solr }
    it "indexes bbox field" do
      expect(subject.keys).to include 'georss_box_tesim'
    end
  end
end
