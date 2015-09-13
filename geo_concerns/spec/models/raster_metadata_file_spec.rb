require 'spec_helper'

describe RasterMetadataFile do
  let(:user) { FactoryGirl.find_or_create(:jill) }

  # For the PCDM File Resource
  let(:file)                { subject.files.build }

  before do
    subject.apply_depositor_metadata('depositor')
    subject.save!
    
    file.content = "I'm a file"
  end

  before do
    subject.files = [file]
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

  describe 'metadata' do
    it 'has a metadata schema' do
      expect(subject).to respond_to(:conforms_to)
    end
  end

  describe '#related_files' do
    let!(:f1) { described_class.new }

    context 'when there are related files' do
      let(:parent_raster)   { FactoryGirl.create(:raster_with_files, title: ['Test title 2'], georss_box: '17.881242 -179.14734 71.390482 179.778465') }
      let(:f1)            { parent_raster.raster_files.first }
      let(:f2)            { parent_raster.raster_files.last }
      let(:files) { f1.reload.related_files }
      it 'returns all raster_files contained in parent raster(s) but excludes itself' do
        expect(files).to include(f2)
        expect(files).to_not include(f1)
      end
    end
  end

  describe 'raster associations' do
    let(:raster) { FactoryGirl.create(:raster_with_one_file, title: ['Test title 3'], georss_box: '17.881242 -179.14734 71.390482 179.778465') }
    subject { raster.raster_files.first.reload }
    it 'belongs to raster' do
      expect(subject.raster).to eq raster
    end
  end
end
