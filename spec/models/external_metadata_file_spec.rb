# Generated via
#  `rails generate curation_concerns:work ExternalMetadataFile`
require 'rails_helper'
require 'spec_helper'

describe ExternalMetadataFile do
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

  it 'updates the title' do
    subject.attributes = { title: ['A raster metadata file'] }
    expect(subject.title).to eq(['A raster metadata file'])
  end

  it 'updates the metadata schema' do
    subject.attributes = { conforms_to: 'ISO19139' }
    expect(subject.conforms_to).to eq('ISO19139')
  end

  describe 'metadata' do
    it 'has a metadata schema' do
      expect(subject).to respond_to(:conforms_to)
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

  describe "to_solr" do
    let(:solr_doc) { FactoryGirl.build(:external_metadata_file,
                                 date_uploaded: Date.today,
                                 conforms_to: 'ISO19139').to_solr
    }

    it "indexes bbox field" do
      expect(solr_doc.keys).to include 'conforms_to_tesim'
    end
  end
end
