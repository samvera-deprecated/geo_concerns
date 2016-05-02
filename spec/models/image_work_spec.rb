require 'spec_helper'

describe ImageWork do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  let(:image_file1) { FileSet.new(mime_type: 'image/jpeg') }
  let(:ext_metadata_file1) { FileSet.new(mime_type: 'application/xml; schema=iso19139') }
  let(:ext_metadata_file2) { FileSet.new(mime_type: 'application/xml; schema=iso19139') }
  let(:raster1) { RasterWork.new }
  let(:raster2) { RasterWork.new }
  let(:coverage) { GeoConcerns::Coverage.new(43.039, -69.856, 42.943, -71.032) }

  it 'updates the title' do
    subject.attributes = { title: ['An image work'] }
    expect(subject.title).to eq(['An image work'])
  end

  describe 'metadata' do
    it 'has descriptive metadata' do
      expect(subject).to respond_to(:title)
    end
  end

  describe 'with acceptable inputs' do
    subject { described_class.new }
    it 'adds image file set, metadata file set, and raster work' do
      subject.members << image_file1
      subject.members << ext_metadata_file1
      subject.members << ext_metadata_file2
      subject.members << raster1
      subject.members << raster2
      expect(subject.image_file).to eq image_file1
      expect(subject.metadata_files).to eq [ext_metadata_file1, ext_metadata_file2]
      expect(subject.raster_works).to eq [raster1, raster2]
    end
    it 'defines what type of object it is' do
      expect(subject.image_work?).to be_truthy
      expect(subject.image_file?).to be_falsey
      expect(subject.raster_work?).to be_falsey
      expect(subject.raster_file?).to be_falsey
      expect(subject.vector_work?).to be_falsey
      expect(subject.vector_file?).to be_falsey
      expect(subject.external_metadata_file?).to be_falsey
    end
  end

  context 'georeferenced to a raster' do
    subject { FactoryGirl.create(:image_work_with_raster_works, title: ['Test title 4'], coverage: coverage.to_s) }

    it 'aggregates by raster resources' do
      expect(subject.raster_works.size).to eq 2
      expect(subject.raster_works.first).to be_kind_of RasterWork
    end
  end

  describe 'populate_metadata' do
    subject { FactoryGirl.create(:image_work_with_one_metadata_file) }
    let(:doc) { Nokogiri::XML(read_test_data_fixture('McKay/S_566_1914_clip_iso.xml')) }

    it 'has an extraction method' do
      expect(subject).to respond_to(:extract_metadata)
    end

    it 'can perform extraction and set properties for ISO 19139' do
      external_metadata_file = subject.metadata_files.first
      allow(external_metadata_file).to receive(:metadata_xml) { doc }
      allow(external_metadata_file).to receive(:mime_type) { 'application/xml; schema=iso19139' }
      subject.populate_metadata
      expect(subject.title).to eq(['S_566_1914_clip.tif'])
    end
  end

  # Please see https://github.com/geoblacklight/geoblacklight-schema/blob/master/docs/geoblacklight-schema.markdown
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

    let(:solr_doc) { FactoryGirl.build(:image_work,
                                       date_uploaded: Time.zone.today,
                                       title: ['an image file'], # @todo This must be restructured as a scalar value
                                       identifier: ['urn:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'], # @todo This too must be restructured as a scalar value
                                       description: ['lorem ipsum'], # @todo Scalar
                                       rights: ['Public'], # @todo Scalar
                                       provenance: 'Test Institution',
                                       references: references.to_s,
                                       coverage: 'ENVELOPE(76.76, 84.76, 19.91, 12.62)',
                                       creator: ['Person A', 'Person B'],
                                       format: 'image/tiff',
                                       language: ['English'],
                                       publisher: ['ML InfoMap'],
                                       subject: ['Census', 'Human settlements'],
                                       spatial: ['Paris, France'],
                                       temporal: ['1989', 'circa 2010', '2007-2009'],
                                       issued: '1990-01-01T00:00:00Z',
                                       part_of: ['Village Maps of India']
                                       ).to_solr
    }

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
end
