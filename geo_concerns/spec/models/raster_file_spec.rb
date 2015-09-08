require 'spec_helper'

# Like the GenericFile spec for CurationConcerns, this test should cover both the GenericFileBehavior module and the generated GenericFile model
describe RasterFile do
  let(:user) { FactoryGirl.find_or_create(:jill) }

  # For the PCDM File Resource
  let(:file)                { subject.files.build }
  let(:pcdm_preview_uri)  { ::RDF::URI('http://pcdm.org/use#ThumbnailImage') } # This seems to encompasses cases such as preview images
  let(:preview) do
    file = subject.files.build
    Hydra::PCDM::AddTypeToFile.call(file, pcdm_preview_uri)
  end

  before do
    subject.files = [file]
  end

  # The GeoTIFF case
  describe '#original_file' do
    context 'when an original file is present' do
      before do
        original_file = subject.build_original_file
        original_file.content = 'original_file'
      end
      subject { subject.original_file }

      it 'can be saved without errors' do
        expect(subject.save).to be_truthy
      end
      it 'retrieves content of the original_file as a PCDM File' do
        expect(subject.content).to eql 'original_file'
        expect(subject).to be_instance_of Hydra::PCDM::File
      end
      it 'retains origin pcdm.File RDF type' do
        expect(subject.original_file.metadata_node.type).to include(Hydra::PCDM::Vocab::PCDMTerms.File)
      end
    end
  end

  # The JPEG2000 case
  describe '#preview' do
    context 'when a preview is present' do
      before do
        original_file = subject.build_preview
        original_file.content = 'preview'
      end
      subject { subject.preview }
      it 'retrieves content of the preview' do
        expect(subject.content).to eql 'preview'
      end
      it 'retains origin pcdm.File RDF type' do
        expect(subject.metadata_node.type).to include(Hydra::PCDM::Vocab::PCDMTerms.File)
      end
    end

    context 'when building new thumbnail' do
      subject { subject.build_thumbnail }
      it 'initializes an unsaved File object with Thumbnail type' do
        expect(subject).to be_new_record
        expect(subject.metadata_node.type).to include(pcdm_thumbnail_uri)
        expect(subject.metadata_node.type).to include(Hydra::PCDM::Vocab::PCDMTerms.File)
      end
    end
  end


  it 'has attached content' do

    expect(subject.association(:original_file).to be_kind_of ActiveFedora::Associations::DirectlyContainsOneAssociation)
  end

  describe 'metadata' do
    it 'has an authoritative CRS' do
      expect(subject).to respond_to(:crs)
    end
  end

  # Relationships between Raster and RasterFiles
  # Following GenericFile/GenericWork, related RasterFile instances are members of any given Raster
  describe '#related_files' do
    let!(:f1) { described_class.new }

    context 'when there are related files' do
      let(:parent_raster)   { FactoryGirl.create(:raster_with_files) }
      let(:f1)            { parent_raster.raster_files.first }
      let(:f2)            { parent_raster.raster_files.last }
      subject { f1.reload.related_files }
      it 'returns all raster_files contained in parent raster(s) but excludes itself' do
        expect(subject).to include(f2)
        expect(subject).to_not include(f1)
      end
    end
  end

  describe 'raster associations' do
    let(:raster) { FactoryGirl.create(:raster_with_one_file) }
    subject { raster.raster_files.first.reload }
    it 'belongs to rasters' do
      expect(subject.raster_rasters).to eq [raster]
    end
  end

  describe "with a GeoTIFF" do
    before do

      Hydra::Works::AddFileToGenericFile.call(subject, File.open("#{fixture_path}/image0.tif", 'rb'), :original_file)
    end

    it 'is georeferenced to a bbox' do
    
      expect(subject.georss_box).to eq '-12.511 109.036 129.0530000 -5.0340000'
    end

    it 'has a CRS' do

      expect(subject.crs).to eq 'urn:ogc:def:crs:EPSG::6326'
    end
  end
end
