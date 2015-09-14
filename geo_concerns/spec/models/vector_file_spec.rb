require 'spec_helper'

# Like the GenericFile spec for CurationConcerns, this test should cover both the GenericFileBehavior module and the generated GenericFile model
describe VectorFile do
  let(:user) { FactoryGirl.find_or_create(:jill) }

  # For the PCDM File Resource
  let(:file)                { subject.files.build }

  before do
    subject.apply_depositor_metadata('depositor')
    subject.save!
    
    file.content = "Shapefile content"
  end

  before do
    subject.files = [file]
  end

  it 'updates the title' do
    subject.attributes = { title: ['A raster file'] }
    expect(subject.title).to eq(['A raster file'])
  end

  it 'updates the bounding box' do
    subject.attributes = { georss_box: '17.881242 -179.14734 71.390482 179.778465' }
    expect(subject.georss_box).to eq('17.881242 -179.14734 71.390482 179.778465')
  end

  it 'updates the CRS' do
    subject.attributes = { crs: 'urn:ogc:def:crs:EPSG::6326' }
    expect(subject.crs).to eq('urn:ogc:def:crs:EPSG::6326')
  end

  describe 'metadata' do
    it 'has descriptive metadata' do
      expect(subject).to respond_to(:title)
    end

    it 'has geospatial metadata' do
      expect(subject).to respond_to(:georss_box)
    end

    it 'has an authoritative CRS' do
      expect(subject).to respond_to(:crs)
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

  it 'has attached content' do
    expect(subject.association(:original_file)).to be_kind_of ActiveFedora::Associations::DirectlyContainsOneAssociation
  end

  describe '#related_files' do
    let!(:f1) { described_class.new }

    context 'when there are related files' do
      let(:parent_vector)   { FactoryGirl.create(:vector_with_files, title: ['Test title 2'], georss_box: '17.881242 -179.14734 71.390482 179.778465') }
      let(:f1)            { parent_vector.vector_files.first }
      let(:f2)            { parent_vector.vector_files.last }
      let(:files) { f1.reload.related_files }
      it 'returns all vector_files contained in parent vector(s) but excludes itself' do
        expect(files).to include(f2)
        expect(files).to_not include(f1)
      end
    end
  end

  describe 'vector associations' do
    let(:vector) { FactoryGirl.create(:vector_with_one_file, title: ['Test title 3'], georss_box: '17.881242 -179.14734 71.390482 179.778465') }
    subject { vector.vector_files.first.reload }
    it 'belongs to vector' do
      expect(subject.vector).to eq vector
    end
  end

  describe "to_solr" do
    let(:solr_doc) { FactoryGirl.build(:vector_file,
                                 date_uploaded: Date.today,
                                 georss_box: '17.881242 -179.14734 71.390482 179.778465',
                                 crs: 'urn:ogc:def:crs:EPSG::6326').to_solr
    }

    it "indexes bbox field" do
      expect(solr_doc.keys).to include 'georss_box_tesim'
      expect(solr_doc.keys).to include 'crs_tesim'
    end
  end
end
