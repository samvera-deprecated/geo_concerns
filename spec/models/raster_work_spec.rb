# Generated via
#  `rails generate curation_concerns:work Raster`
require 'rails_helper'

describe RasterWork do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  let(:raster_file1) { FileSet.new(mime_type: 'image/tiff; gdal-format=GTiff') }
  let(:raster_file2) { FileSet.new(mime_type: 'image/tiff; gdal-format=GTiff') }
  let(:ext_metadata_file1) { FileSet.new(mime_type: 'application/xml; schema=iso19139') }
  let(:ext_metadata_file2) { FileSet.new(mime_type: 'application/xml; schema=iso19139') }
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
    it 'add rasterfile,metadata,vector to file' do
      subject.members << raster_file1
      subject.members << raster_file2
      subject.members << ext_metadata_file1
      subject.members << ext_metadata_file2
      subject.members << vector1
      subject.members << vector2
      expect(subject.raster_files).to eq [raster_file1, raster_file2]
      expect(subject.metadata_files).to eq [ext_metadata_file1, ext_metadata_file2]
      expect(subject.vector_works).to eq [vector1, vector2]
    end
  end

  context 'with raster files' do
    subject { FactoryGirl.create(:raster_work_with_files, title: ['Test title 4'], coverage: coverage.to_s) }

    it 'has two files' do
      expect(subject.raster_files.size).to eq 2
      expect(subject.raster_files.first.mime_type).to eq 'image/tiff; gdal-format=GTiff'
    end
  end

  context 'with vector feature extractions' do
    subject { FactoryGirl.create(:raster_work_with_vector_works) }

    it 'aggregates vector data set resources' do
      expect(subject.vector_works.size).to eq 2
      expect(subject.vector_works.first).to be_kind_of VectorWork
    end
  end

  context 'with metadata files' do
    subject { FactoryGirl.create(:raster_work_with_metadata_files) }

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

    let(:solr_doc) { FactoryGirl.build(:raster_work,
                                       date_uploaded: Time.zone.today,
                                       title: ['an image file'], # @todo This must be restructured as a scalar value
                                       identifier: ['urn:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'], # @todo This too must be restructured as a scalar value
                                       description: ['lorem ipsum'], # @todo Scalar
                                       rights: ['Public'], # @todo Scalar
                                       references: references.to_s,
                                       coverage: 'ENVELOPE(76.76, 84.76, 19.91, 12.62)',
                                       creator: ['Person A', 'Person B'],
                                       format: 'GeoTIFF',
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
    subject { FactoryGirl.create(:raster_work_with_one_metadata_file) }
    let(:doc) { Nokogiri::XML(read_test_data_fixture('McKay/S_566_1914_clip_iso.xml')) }

    it 'has an extraction method' do
      expect(subject).to respond_to(:extract_metadata)
    end

    it 'can perform extraction and set properties for ISO 19139' do
      external_metadata_file = subject.metadata_files.first
      allow(external_metadata_file).to receive(:metadata_xml).and_return(doc)
      allow(external_metadata_file).to receive(:mime_type).and_return('application/xml; schema=iso19139')
      subject.populate_metadata
      expect(subject.title).to eq(['S_566_1914_clip.tif'])
    end
  end
end
