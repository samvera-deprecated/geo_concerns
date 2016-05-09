require 'spec_helper'

describe FileSet do
  let(:user) { create(:user) }
  subject { described_class.new(mime_type: 'image/jpeg') }

  context "when geo_file_format is an image format" do
    it "responds as an image file" do
      expect(subject.image_file?).to be_truthy
    end
    it "doesn't respond as a vector file" do
      expect(subject.vector_file?).to be_falsey
    end
    it 'does not have an authoritative cartographic projection' do
      # expect(subject).not_to respond_to(:cartographic_projection)
      skip 'Our models for FileSet always include cartographic_projection'
    end
  end

  describe 'image work association' do
    let(:work) { FactoryGirl.create(:image_work_with_one_file) }
    subject { work.file_sets.first.reload }
    it 'belongs to image work' do
      expect(subject.image_work).to eq [work]
    end
  end

  # Please see https://github.com/geoblacklight/geoblacklight-schema/blob/master/docs/dct_references_schema.markdown
  describe "to_solr" do
    let(:solr_doc) { FactoryGirl.build(:image_file,
                                       date_uploaded: Time.zone.today,
                                       cartographic_projection: 'urn:ogc:def:crs:EPSG::6326',
                                       title: ['an image file'], # @todo This must be restructured as a scalar value
                                       identifier: ['urn:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'], # @todo This too must be restructured as a scalar value
                                       description: ['lorem ipsum'], # @todo Scalar
                                       rights: ['Public'], # @todo Scalar
                                       provenance: 'Test Institution',
                                       references: {
                                         "http://schema.org/url" => "http://purl.stanford.edu/bb509gh7292",
                                         "http://schema.org/downloadUrl" => "http://stacks.stanford.edu/file/druid:bb509gh7292/data.zip",
                                         "http://www.loc.gov/mods/v3" => "http://purl.stanford.edu/bb509gh7292.mods",
                                         "http://www.isotc211.org/schemas/2005/gmd/" => "http://opengeometadata.stanford.edu/metadata/edu.stanford.purl/druid:bb509gh7292/iso19139.xml",
                                         "http://www.w3.org/1999/xhtml" => "http://opengeometadata.stanford.edu/metadata/edu.stanford.purl/druid:bb509gh7292/default.html",
                                         "http://www.opengis.net/def/serviceType/ogc/wfs" => "https://geowebservices-restricted.stanford.edu/geoserver/wfs",
                                         "http://www.opengis.net/def/serviceType/ogc/wms" => "https://geowebservices-restricted.stanford.edu/geoserver/wms"
                                       }, # Please see https://github.com/geoblacklight/geoblacklight-schema/blob/master/docs/dct_references_schema.markdown
                                       coverage: 'ENVELOPE(76.76, 84.76, 19.91, 12.62)',
                                       modified: '1989-01-01T00:00:00Z',
                                       creator: ['Person A', 'Person B'],
                                       format: 'GeoTIFF',
                                       language: ['English'],
                                       publisher: ['ML InfoMap'],
                                       subject: ['Census', 'Human settlements'],
                                       spatial: ['Paris, France'],
                                       temporal: ['1989', 'circa 2010', '2007-2009'],
                                       date_issued: '1990-01-01T00:00:00Z',
                                       part_of: ['Village Maps of India']
                                       ).to_solr
    }

    it "indexes the coordinate reference system" do
      expect(solr_doc.keys).to include 'cartographic_projection_tesim'
      expect(solr_doc['cartographic_projection_tesim']).to eq 'urn:ogc:def:crs:EPSG::6326'
    end
  end

  describe 'metadata' do
    it 'has descriptive metadata' do
      expect(subject).to respond_to(:title)
    end

    it 'has standard' do
      expect(subject).to respond_to(:mime_type)
    end

    it 'has an authoritative cartographic projection' do
      expect(subject).to respond_to(:cartographic_projection)
    end
  end
end
