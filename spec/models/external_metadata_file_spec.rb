require 'spec_helper'

describe FileSet do
  let(:user) { create(:user) }
  subject { FileSet.new(geo_file_format: 'ISO19139') }

  context "when geo_file_format is a metadata format" do
    it "responds as a metadata file" do
      expect(subject.external_metadata_file?).to be_truthy
    end
    it "doesn't respond as a vector file" do
      expect(subject.vector_file?).to be_falsey
    end
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

  describe 'metadata' do
    it 'has a metadata schema' do
      expect(subject).to respond_to(:conforms_to)
    end
  end

  it 'will read the PCDM::File for its XML' do
    expect(subject).to receive(:original_file) { Hydra::PCDM::File.new }
    expect(subject.metadata_xml).to be_kind_of Nokogiri::XML::Document
  end

  it 'will route the extraction request for ISO' do
    expect(subject).to receive(:original_file) { Hydra::PCDM::File.new }
    expect(subject).to receive(:extract_iso19139_metadata)
    subject.geo_file_format = 'ISO19139'
    expect(subject.extract_metadata).to be_nil
  end

  it 'will route the extraction request for FGDC' do
    expect(subject).to receive(:original_file) { Hydra::PCDM::File.new }
    expect(subject).to receive(:extract_fgdc_metadata)
    subject.geo_file_format = 'Fgdc'
    expect(subject.extract_metadata).to be_nil
  end

  it 'will route the extraction request for MODS' do
    expect(subject).to receive(:original_file) { Hydra::PCDM::File.new }
    expect(subject).to receive(:extract_mods_metadata)
    subject.geo_file_format = 'mods'
    expect(subject.extract_metadata).to be_nil
  end

  it 'will not route the extraction request for bogus standard' do
    subject.geo_file_format = 'bogus'
    expect { subject.extract_metadata }.to raise_error(ArgumentError)
  end

  it 'can extract ISO 19139 metadata - example 1' do
    doc = Nokogiri::XML(read_test_data_fixture('McKay/S_566_1914_clip_iso.xml'))
    expect(subject.extract_iso19139_metadata(doc)).to include({
      title: ['S_566_1914_clip.tif'],
      coverage: GeoConcerns::Coverage.new(57.595712, -109.860605, 56.407644, -112.469675).to_s,
      description: ['This raster file is the result of georeferencing using esri\'s ArcScan of Sheet 566: McKay, Alberta, 1st ed. 1st of July, 1914. This sheet is part of the 3-mile to 1-inch sectional maps of Western Canada. vectorization was undertaken to extract a measure of line work density in order to measure Cartographic Intactness. The map series is described in Dubreuil, Lorraine. 1989. Sectional maps of western Canada, 1871-1955: An early Canadian topographic map series. Occasional paper no. 2, Association of Canadian Map Libraries and Archives.'],
      source: ['Larry Laliberte']
    })
  end

  it 'can extract ISO 19139 metadata - example 2' do
    doc = Nokogiri::XML(read_test_data_fixture('McKay/S_566_1914_lines_iso.xml'))
    expect(subject.extract_iso19139_metadata(doc)).to include({
      title: ['S_566_1914_lines'],
      coverage: GeoConcerns::Coverage.new(57.450728, -109.898613, 56.600872, -112.1975).to_s,
      description: ['This .shp file (lines) is the result of georeferencing and performing a raster to vector conversion using esri\'s ArcScan of Sheet 566: McKay, Alberta, 1st ed. 1st of July, 1914. This sheet is part of the 3-mile to 1-inch sectional maps of Western Canada. vectorization was undertaken to extract a measure of line work density in order to measure Cartographic Intactness. The map series is described in Dubreuil, Lorraine. 1989. Sectional maps of western Canada, 1871-1955: An early Canadian topographic map series. Occasional paper no. 2, Association of Canadian Map Libraries and Archives.'],
      source: ['Larry Laliberte']
    })
  end

  it 'can extract FGDC metadata - example 1' do
    doc = Nokogiri::XML(read_test_data_fixture('zipcodes_fgdc.xml'))
    expect(subject.extract_fgdc_metadata(doc)).to include({
      title: ['Louisiana ZIP Code Areas 2002'],
      coverage: GeoConcerns::Coverage.new(33.019481, -88.817478, 28.926478, -94.043286).to_s,
      creator: ['Geographic Data Technology, Inc. (GDT)', 'Environmental Systems Research Institute, Inc. (ESRI)'],
      description: ['Louisiana ZIP Code Areas represents five-digit ZIP Code areas used by the U.S. Postal Service to deliver mail more effectively.  The first digit of a five-digit ZIP Code divides the country into 10 large groups of states numbered from 0 in the Northeast to 9 in the far West.  Within these areas, each state is divided into an average of 10 smaller geographical areas, identified by the 2nd and 3rd digits.  These digits, in conjunction with the first digit, represent a sectional center facility or a mail processing facility area.  The 4th and 5th digits identify a post office, station, branch or local delivery area.'],
      issued: 2002,
      subject: ["polygon", "zip codes", "areas", "five-digit zip codes", "post offices", "population", "Location", "Society"],
      publisher: 'Environmental Systems Research Institute, Inc. (ESRI)'
    })
  end

  it 'can extract FGDC metadata - example 2' do
    doc = Nokogiri::XML(read_test_data_fixture('McKay/S_566_1914_clip_fgdc.xml'))
    expect(subject.extract_fgdc_metadata(doc)).to include({
      title: ['S_566_1914_clip.tif'],
      coverage: GeoConcerns::Coverage.new(57.465375, -109.622454, 56.580532, -112.47033).to_s,
      description: ['This raster file is the result of georeferencing using esri\'s ArcScan of Sheet 566: McKay, Alberta, 1st ed. 1st of July, 1914. This sheet is part of the 3-mile to 1-inch sectional maps of Western Canada. vectorization was undertaken to extract a measure of line work density in order to measure Cartographic Intactness. The map series is described in Dubreuil, Lorraine. 1989. Sectional maps of western Canada, 1871-1955: An early Canadian topographic map series. Occasional paper no. 2, Association of Canadian Map Libraries and Archives.'],
      issued: 2014,
      subject: ["Land cover", "Land use, rural", "Society", "Imagery and Base Maps", "Biology and Ecology"]
    })
  end

  it 'can extract FGDC metadata - example 3' do
    doc = Nokogiri::XML(read_test_data_fixture('McKay/S_566_1914_lines_fgdc.xml'))
    expect(subject.extract_fgdc_metadata(doc)).to include({
      title: ['S_566_1914_lines'],
      coverage: GeoConcerns::Coverage.new(57.450728, -109.898613, 56.600872, -112.1975).to_s,
      description: ['This .shp file (lines) is the result of georeferencing and performing a raster to vector conversion using esri\'s ArcScan of Sheet 566: McKay, Alberta, 1st ed. 1st of July, 1914. This sheet is part of the 3-mile to 1-inch sectional maps of Western Canada. vectorization was undertaken to extract a measure of line work density in order to measure Cartographic Intactness. The map series is described in Dubreuil, Lorraine. 1989. Sectional maps of western Canada, 1871-1955: An early Canadian topographic map series. Occasional paper no. 2, Association of Canadian Map Libraries and Archives.'],
      issued: 2014,
      temporal: ['1914'],
      spatial: ['McKay (Alta.)', 'Fort McMurray (Alta.)', 'Alberta', 'Western Canada'],
      subject: ["Land cover", "Land use, rural", "Biology and Ecology", "Environment", "Imagery and Base Maps", "Society"]
    })
  end

  it 'can extract MODS metadata' do
    doc = Nokogiri::XML(read_test_data_fixture('bb099zb1450_mods.xml'))
    expect(subject.extract_mods_metadata(doc)).to include({
      title: ['Department Boundary: Haute-Garonne, France, 2010 '],
      description: ['This polygon shapefile represents the Department Boundary for the Haute-Garonne department of France for 2010. These are the level 2 administrative divisions (ADM2) of Haute-Garonne. Department is one of the three levels of government below the national level ("territorial collectivities"), between the region and the commune. There are 96 departments in metropolitan France and 5 overseas departments, which also are classified as regions. Departments are further subdivided into 342 arrondissements, themselves divided into cantons; the latter two have no autonomy and are used for the organisation of public services and sometimes elections.']
    })
  end
end
