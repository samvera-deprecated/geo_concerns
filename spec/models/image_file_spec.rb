require 'spec_helper'

describe FileSet do
  let(:user) { create(:user) }
  subject { FileSet.new(geo_file_format: 'TIFF') }

  context "when geo_file_format is an image format" do
    it "responds as an image file" do
      expect(subject.image_file?).to be_truthy
    end
    it "doesn't respond as a vector file" do
      expect(subject.vector_file?).to be_falsey
    end
  end

  describe 'image work association' do
    let(:work) { FactoryGirl.create(:image_work_with_one_file) }
    subject { work.file_sets.first.reload }
    it 'belongs to image work' do
      expect(subject.image_work).to eq [work]
    end
  end

  describe "to_solr" do
    let(:solr_doc) { FactoryGirl.build(:image_file,
                                       date_uploaded: Date.today,
                                       cartographic_projection: 'urn:ogc:def:crs:EPSG::6326',
                                       title: 'an image file',
                                       identifier: 'urn:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
                                       description: 'lorem ipsum',
                                       rights: 'Public',
                                       provenance: 'Test Institution',
                                       references: {
                                         "http://schema.org/url":"http://purl.stanford.edu/bb509gh7292",
                                         "http://schema.org/downloadUrl":"http://stacks.stanford.edu/file/druid:bb509gh7292/data.zip",
                                         "http://www.loc.gov/mods/v3":"http://purl.stanford.edu/bb509gh7292.mods",
                                         "http://www.isotc211.org/schemas/2005/gmd/":"http://opengeometadata.stanford.edu/metadata/edu.stanford.purl/druid:bb509gh7292/iso19139.xml",
                                         "http://www.w3.org/1999/xhtml":"http://opengeometadata.stanford.edu/metadata/edu.stanford.purl/druid:bb509gh7292/default.html",
                                         "http://www.opengis.net/def/serviceType/ogc/wfs":"https://geowebservices-restricted.stanford.edu/geoserver/wfs",
                                         "http://www.opengis.net/def/serviceType/ogc/wms":"https://geowebservices-restricted.stanford.edu/geoserver/wms"
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
    end

    context "as required by the GeoBlacklight Schema" do
      it "indexes the UUID" do
        expect(solr_doc.keys).to include 'uuid'
      end

      it "derives the UUID from the ID for the FileSet" do
        expect(solr_doc[:uuid]).to eq solr_doc[:id]
      end

      context "for all elements within the Dublin Core namespace" do
        
        %w{ dc_identifier_s dc_title_s dc_description_s dc_rights_s }.each do |dc_element|
          
          it "indexes the Dublin Core element #{dc_element} with single values" do
            expect(solr_doc.keys).to include dc_element
            expect(solr_doc[dc_element]).to be_a String
          end
        end

        it "derives the dc_rights_s from the visibility for the FileSet" do
          expect(solr_doc[:dc_rights_s]).to eq solr_doc[:visibility]
        end
      end

      context "for all elements within the Dublin Core terms namespace" do
        
        %w{ dct_provenance_s }.each do |dct_element|
          
          it "indexes the Dublin Core element #{dct_element} with a single value" do
            expect(solr_doc.keys).to include dct_element
            expect(solr_doc[dct_element]).to be_a String
          end
        end

        it "derives dct_references_s from a system config. value" do
          expect(solr_doc[:dct_references_s]).to eq GeoConcerns.ext_references
        end
      end

      context "for all elements within the GeoRSS namespace" do
        
        %w{ georss_box_s }.each do |geo_rss_element|
          
          it "indexes the GeoRSS element #{geo_rss_element} with a single value" do
            expect(solr_doc.keys).to include geo_rss_element
            expect(solr_doc[geo_rss_element]).to be_a String
          end
        end

        it "derives georss_box_s from dc_coverage_s" do
          expect(solr_doc[:georss_box_s]).to eq solr_doc[:dc_coverage_s]
        end
      end

      context "for all elements within the layer namespace" do

        %w{ layer_id_s layer_geom_type_s layer_modified_dt layer_slug_s }.each do |layer_element|
          
          it "indexes the Dublin Core element #{layer_element}" do
            expect(solr_doc.keys).to include layer_element
          end
        end

        it 'derives layer_id_s from dct_references' do
          expect(solr_doc[:layer_id_s]).to eq solr_doc[:dct_references_s]
        end

        it 'derives layer_slug_s from the ID for the FileSet' do
          expect(solr_doc[:layer_slug_s]).to eq solr_doc[:id]
        end

      end

      it "indexes the Solr geometry field value" do
        expect(solr_doc.keys).to include 'solr_geom'
      end

      it 'derives solr_geom from georss_box' do
        expect(solr_doc[:solr_geom]).to eq solr_doc[:georss_box]
      end
      
      it "indexes the Solr year field value" do
        expect(solr_doc.keys).to include 'solr_year_i'
      end
      
      it 'derives solr_year_i from dct_temporal' do
        expect(solr_doc[:solr_year_i]).to eq solr_doc[:dct_temporal]
      end

      
    end

    context "optional for the GeoBlacklight Schema" do

      context "for all elements within the Dublin Core namespace" do
        
        %w{ dc_creator_sm dc_subject_sm }.each do |dc_element|
          it "indexes the Dublin Core element #{dc_element} with multiple values" do
            expect(solr_doc.keys).to include dc_element
          end
        end

        %w{ dc_format_s }.each do |dc_element|
          it "indexes the Dublin Core element #{dc_element}" do
            expect(solr_doc.keys).to include dc_element
          end
        end

        %w{ dc_language_s dc_publisher_s dc_type_s }.each do |dc_element|
          it "indexes the Dublin Core element #{dc_element} with single values" do
            expect(solr_doc.keys).to include dc_element
          end
        end
      end

      context "for all elements within the Dublin Core terms namespace" do

#        %w{ dct_references_s dct_spatial_sm dct_temporal_sm dct_issued_dt dct_isPartOf_sm }.each do |dct_element|
        %w{ dct_spatial_sm dct_temporal_sm dct_issued_dt dct_isPartOf_sm }.each do |dct_element|
          
          it "indexes the Dublin Core terms element #{dct_element}" do
            expect(solr_doc.keys).to include dct_element
          end
        end
      end

    end
  end

  describe 'metadata' do
    it 'has descriptive metadata' do
      expect(subject).to respond_to(:title)
    end

    it 'has an authoritative cartographic projection' do
      expect(subject).to respond_to(:cartographic_projection)
    end
  end
end
