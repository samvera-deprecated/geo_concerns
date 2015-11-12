# Generated via
#  `rails generate curation_concerns:work RasterFile`
require 'rails_helper'
require 'spec_helper'

# Like the GenericFile spec for CurationConcerns, this test should cover both the GenericFileBehavior module and the generated GenericFile model
describe RasterFile do
  let(:user) { FactoryGirl.find_or_create(:jill) }

  # For the PCDM File Resource
  let(:file)                { subject.files.build }

  before do
    subject.apply_depositor_metadata('depositor')
    subject.save!
    
    file.content = "I'm a file"
  end

  let(:pcdm_preview_uri)  { ::RDF::URI('http://pcdm.org/use#ThumbnailImage') } # This seems to encompasses cases such as preview images
  let(:preview) do
    file = subject.files.build
    Hydra::PCDM::AddTypeToFile.call(file, pcdm_preview_uri)
  end

  before do
    subject.files = [file]
  end

  it 'updates the title' do
    subject.attributes = { title: ['A raster file'] }
    expect(subject.title).to eq(['A raster file'])
  end

  it 'updates the bounding box' do
    subject.attributes = { bounding_box: '17.881242 -179.14734 71.390482 179.778465' }
    expect(subject.bounding_box).to eq('17.881242 -179.14734 71.390482 179.778465')
  end

  it 'updates the cartographic projection' do
    subject.attributes = { cartographic_projection: 'urn:ogc:def:crs:EPSG::6326' }
    expect(subject.cartographic_projection).to eq('urn:ogc:def:crs:EPSG::6326')
  end

  describe 'metadata' do
    it 'has descriptive metadata' do
      expect(subject).to respond_to(:title)
    end

    it 'has geospatial metadata' do
      expect(subject).to respond_to(:bounding_box)
    end

    it 'has an authoritative cartographic projection' do
      expect(subject).to respond_to(:cartographic_projection)
    end
  end

  describe '#original_file' do
    context 'when an original file is present' do
      before do
        original_file = subject.build_original_file
        original_file.content = 'original_file'
      end
      let(:original_file) { subject.original_file } # Using `subject` raises a SystemStackError in relation to recursion

      it 'can be saved without errors' do
        expect(original_file.save).to be_truthy
      end
      it 'retrieves content of the original_file as a PCDM File' do
        expect(original_file.content).to eql 'original_file'
        expect(original_file).to be_instance_of Hydra::PCDM::File
      end
      it 'retains origin pcdm.File RDF type' do
        expect(original_file.metadata_node.type).to include(Hydra::PCDM::Vocab::PCDMTerms.File)
      end
    end
  end

  describe '#preview' do
    context 'when a preview is present' do
      before do
        original_file = subject.build_thumbnail
        original_file.content = 'preview'
      end
      let(:preview) { subject.preview } # Using subject.preview as a subject leads to recursive error
      it 'retrieves content of the preview' do
        expect(preview.content).to eql 'preview'
      end
      it 'retains origin pcdm.File RDF type' do
        expect(preview.metadata_node.type).to include(Hydra::PCDM::Vocab::PCDMTerms.File)
      end
    end

    context 'when building new thumbnail' do
      let(:preview) { subject.build_thumbnail } # Using subject.preview as a subject leads to recursive error
      it 'initializes an unsaved File object with Thumbnail type' do
        expect(preview).to be_new_record
        expect(preview.metadata_node.type).to include(pcdm_preview_uri)
        expect(preview.metadata_node.type).to include(Hydra::PCDM::Vocab::PCDMTerms.File)
      end
    end
  end

  it 'has attached content' do
    expect(subject.association(:original_file)).to be_kind_of ActiveFedora::Associations::DirectlyContainsOneAssociation
  end

  describe "to_solr" do
    let(:solr_doc) { FactoryGirl.build(:raster_file,
                                 date_uploaded: Date.today,
                                 bounding_box: '17.881242 -179.14734 71.390482 179.778465',
                                 cartographic_projection: 'urn:ogc:def:crs:EPSG::6326').to_solr
    }

    it "indexes the bounding box" do
      expect(solr_doc.keys).to include 'bounding_box_tesim'
    end
    it "indexes the cartographic projection" do
      expect(solr_doc.keys).to include 'cartographic_projection_tesim'
    end
  end
end
