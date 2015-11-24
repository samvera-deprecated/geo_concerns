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
  
  it 'will read the PCDM::File for its XML' do
    expect(subject).to receive(:original_file) { Hydra::PCDM::File.new }
    expect(subject.metadata_xml).to be_kind_of Nokogiri::XML::Document
  end

  it 'will route the extraction request for ISO' do
    expect(subject).to receive(:original_file) { Hydra::PCDM::File.new }
    expect(subject).to receive(:extract_iso19139_metadata)
    subject.conforms_to = 'ISO19139'
    expect(subject.extract_metadata).to be_nil
  end

  it 'will route the extraction request for FGDC' do
    expect(subject).to receive(:original_file) { Hydra::PCDM::File.new }
    expect(subject).to receive(:extract_fgdc_metadata)
    subject.conforms_to = 'Fgdc'
    expect(subject.extract_metadata).to be_nil
  end

  it 'will route the extraction request for MODS' do
    expect(subject).to receive(:original_file) { Hydra::PCDM::File.new }
    expect(subject).to receive(:extract_mods_metadata)
    subject.conforms_to = 'mods'
    expect(subject.extract_metadata).to be_nil
  end

  it 'will not route the extraction request for bogus standard' do
    subject.conforms_to = 'bogus'
    expect { subject.extract_metadata }.to raise_error(RuntimeError)
  end

  it 'can extract ISO 19139 metadata - example 1' do
    doc = Nokogiri::XML(read_test_data_fixture('McKay/S_566_1914_clip_iso.xml'))
    expect(subject.extract_iso19139_metadata(doc)).to include({ 
      title: ['S_566_1914_clip.tif'],
      bounding_box: '56.407644 -112.469675 57.595712 -109.860605',
      description: ['This raster file is the result of georeferencing using esri\'s ArcScan of Sheet 566: McKay, Alberta, 1st ed. 1st of July, 1914. This sheet is part of the 3-mile to 1-inch sectional maps of Western Canada. vectorization was undertaken to extract a measure of line work density in order to measure Cartographic Intactness. The map series is described in Dubreuil, Lorraine. 1989. Sectional maps of western Canada, 1871-1955: An early Canadian topographic map series. Occasional paper no. 2, Association of Canadian Map Libraries and Archives.'],
      source: ['Larry Laliberte']
    })
  end

  it 'can extract ISO 19139 metadata - example 2' do
    doc = Nokogiri::XML(read_test_data_fixture('McKay/S_566_1914_lines_iso.xml'))
    expect(subject.extract_iso19139_metadata(doc)).to include({ 
      title: ['S_566_1914_lines'],
      bounding_box: '56.600872 -112.1975 57.450728 -109.898613',
      description: ['This .shp file (lines) is the result of georeferencing and performing a raster to vector conversion using esri\'s ArcScan of Sheet 566: McKay, Alberta, 1st ed. 1st of July, 1914. This sheet is part of the 3-mile to 1-inch sectional maps of Western Canada. vectorization was undertaken to extract a measure of line work density in order to measure Cartographic Intactness. The map series is described in Dubreuil, Lorraine. 1989. Sectional maps of western Canada, 1871-1955: An early Canadian topographic map series. Occasional paper no. 2, Association of Canadian Map Libraries and Archives.'],
      source: ['Larry Laliberte']
    })
  end

  it 'can extract FGDC metadata - example 1' do
    doc = Nokogiri::XML(read_test_data_fixture('zipcodes_fgdc.xml'))
    expect(subject.extract_fgdc_metadata(doc)).to include({ 
      title: ['Louisiana ZIP Code Areas 2002'],
      bounding_box: '28.926478 -94.043286 33.019481 -88.817478',
      creator: ['Geographic Data Technology, Inc. (GDT)'],
      description: ['Louisiana ZIP Code Areas represents five-digit ZIP Code areas used by the U.S. Postal Service to deliver mail more effectively.  The first digit of a five-digit ZIP Code divides the country into 10 large groups of states numbered from 0 in the Northeast to 9 in the far West.  Within these areas, each state is divided into an average of 10 smaller geographical areas, identified by the 2nd and 3rd digits.  These digits, in conjunction with the first digit, represent a sectional center facility or a mail processing facility area.  The 4th and 5th digits identify a post office, station, branch or local delivery area.']
    })
  end
  
  it 'can extract FGDC metadata - example 2' do
    doc = Nokogiri::XML(read_test_data_fixture('McKay/S_566_1914_clip_fgdc.xml'))
    expect(subject.extract_fgdc_metadata(doc)).to include({ 
      title: ['S_566_1914_clip.tif'],
      bounding_box: '56.580532 -112.47033 57.465375 -109.622454',
      description: ['This raster file is the result of georeferencing using esri\'s ArcScan of Sheet 566: McKay, Alberta, 1st ed. 1st of July, 1914. This sheet is part of the 3-mile to 1-inch sectional maps of Western Canada. vectorization was undertaken to extract a measure of line work density in order to measure Cartographic Intactness. The map series is described in Dubreuil, Lorraine. 1989. Sectional maps of western Canada, 1871-1955: An early Canadian topographic map series. Occasional paper no. 2, Association of Canadian Map Libraries and Archives.']
    })
  end

  it 'can extract MODS metadata' do
    doc = Nokogiri::XML(read_test_data_fixture('bb099zb1450_mods.xml'))
    expect(subject.extract_mods_metadata(doc)).to include({
      title: ['Department Boundary: Haute-Garonne, France, 2010 '],
      description: ["This polygon shapefile represents the Department Boundary for the Haute-Garonne department of France for 2010. These are the level 2 administrative divisions (ADM2) of Haute-Garonne. Department is one of the three levels of government below the national level (\"territorial collectivities\"), between the region and the commune. There are 96 departments in metropolitan France and 5 overseas departments, which also are classified as regions. Departments are further subdivided into 342 arrondissements, themselves divided into cantons; the latter two have no autonomy and are used for the organisation of public services and sometimes elections."]
      
    })
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
