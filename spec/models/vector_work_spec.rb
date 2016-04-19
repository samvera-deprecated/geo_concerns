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
    references = {
      "http://schema.org/url" => "http://purl.stanford.edu/bb509gh7292",
      "http://schema.org/downloadUrl" => "http://stacks.stanford.edu/file/druid:bb509gh7292/data.zip",
      "http://www.loc.gov/mods/v3" => "http://purl.stanford.edu/bb509gh7292.mods",
      "http://www.isotc211.org/schemas/2005/gmd/" => "http://opengeometadata.stanford.edu/metadata/edu.stanford.purl/druid:bb509gh7292/iso19139.xml",
      "http://www.w3.org/1999/xhtml" => "http://opengeometadata.stanford.edu/metadata/edu.stanford.purl/druid:bb509gh7292/default.html",
      "http://www.opengis.net/def/serviceType/ogc/wfs" => "https://geowebservices-restricted.stanford.edu/geoserver/wfs",
      "http://www.opengis.net/def/serviceType/ogc/wms" => "https://geowebservices-restricted.stanford.edu/geoserver/wms"
    }

    let(:solr_doc) { FactoryGirl.build(:vector_work,
                                       date_uploaded: Time.zone.today,
                                       title: ['a shapefile'], # @todo This must be restructured as a scalar value
                                       identifier: ['urn:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'], # @todo This too must be restructured as a scalar value
                                       description: ['lorem ipsum'], # @todo Scalar
                                       rights: ['Public'], # @todo Scalar
                                       references: references.to_s,
                                       coverage: 'ENVELOPE(76.76, 84.76, 19.91, 12.62)',
                                       creator: ['Person A', 'Person B'],
                                       format: 'application/octet-stream',
                                       language: ['English'],
                                       publisher: ['ML InfoMap'],
                                       subject: ['Census', 'Human settlements'],
                                       spatial: ['Paris, France'],
                                       temporal: ['1989', 'circa 2010', '2007-2009'],
                                       issued: '1990-01-01T00:00:00Z',
                                       part_of: ['Village Maps of India']
                                       ).to_solr
    }

    it "indexes ordered_by_ssim field" do
      expect(solr_doc.keys).to include 'ordered_by_ssim'
    end

    context "as required by the GeoBlacklight Schema" do
      # There is likely some Redundancy with CurationConcerns metadata
      # https://github.com/projecthydra-labs/curation_concerns/blob/master/app/models/concerns/curation_concerns/basic_metadata.rb
      # https://github.com/projecthydra-labs/curation_concerns/blob/master/app/models/concerns/curation_concerns/required_metadata.rb
      %w{ dc_identifier_s dc_title_s dc_description_s dc_rights_s dct_provenance_s georss_box_s layer_id_s layer_geom_type_s layer_modified_dt layer_slug_s solr_geom solr_year_i }.each do |dc_element|
        it "indexes the Dublin Core element #{dc_element}" do
          expect(solr_doc.keys).to include dc_element
        end
      end
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
