require 'spec_helper'

describe FileSet do
  let(:user) { create(:user) }
  subject { FileSet.new(conforms_to: 'SHAPEFILE') }

  context "when conforms_to is a vector format" do
    it "responds as a vector file" do
      expect(subject.vector_file?).to be_truthy
    end
    it "doesn't respond as a raster file" do
      expect(subject.raster_file?).to be_falsey
    end
  end

  describe 'vector work association' do
    let(:work) { FactoryGirl.create(:vector_work_with_one_file) }
    subject { work.file_sets.first.reload }
    it 'belongs to vector work' do
      expect(subject.vector_work).to eq [work]
    end
  end

  describe "to_solr" do
    let(:solr_doc) { FactoryGirl.build(:vector_file,
                                 date_uploaded: Date.today,
                                 cartographic_projection: 'urn:ogc:def:crs:EPSG::6326').to_solr
    }

    it "indexes the coordinate reference system" do
      expect(solr_doc.keys).to include 'cartographic_projection_tesim'
    end

    it "indexes the coordinate reference system" do
      expect(solr_doc.keys).to include 'cartographic_projection_tesim'
    end

    context "as required by the GeoBlacklight Schema" do
      it "indexes the UUID" do
        expect(solr_doc.keys).to include 'uuid'
      end

      context "for all elements within the Dublin Core namespace" do
        
        # Redundancy with CurationConcerns metadata
        # https://github.com/projecthydra-labs/curation_concerns/blob/f21f2e2071824850fddcc6aedd65c5fb1646e03a/curation_concerns-models/app/models/concerns/curation_concerns/basic_metadata.rb
        %w{ dc_identifier_s dc_title_s dc_description_s dc_rights_s }.each do |dc_element|
          
          it "indexes the Dublin Core element #{dc_element}" do
            expect(solr_doc.keys).to include dc_element
          end
        end
      end

      context "for all elements within the Dublin Core terms namespace" do
        
        %w{ dct_provenance_s }.each do |dct_element|
          
          it "indexes the Dublin Core element #{dct_element}" do
            expect(solr_doc.keys).to include dct_element
          end
        end
      end

      context "for all elements within the GeoRSS namespace" do
        
        %w{ georss_box_s }.each do |geo_rss_element|
          
          it "indexes the GeoRSS element #{geo_rss_element}" do
            expect(solr_doc.keys).to include geo_rss_element
          end
        end
      end

      context "for all elements within the layer namespace" do

        %w{ layer_id_s layer_geom_type_s layer_modified_dt layer_slug_s }.each do |layer_element|
          
          it "indexes the Dublin Core element #{layer_element}" do
            expect(solr_doc.keys).to include layer_element
          end
        end
      end

      it "indexes the Solr geometry field value" do
        expect(solr_doc.keys).to include 'solr_geom'
      end

      it "indexes the Solr year field value" do
        expect(solr_doc.keys).to include 'solr_year_i'
      end
    end

    context "optional for the GeoBlacklight Schema" do

      context "for all elements within the Dublin Core namespace" do
        
        %w{ dc_creator_sm dc_format_s dc_language_s dc_publisher_s dc_subject_sm dc_type_s }.each do |dc_element|
          
          it "indexes the Dublin Core element #{dc_element}" do
            expect(solr_doc.keys).to include dc_element
          end
        end
      end

      context "for all elements within the Dublin Core terms namespace" do

        %w{ dct_references_s dct_spatial_sm dct_temporal_sm dct_issued_dt dct_isPartOf_sm }.each do |dct_element|
          
          it "indexes the Dublin Core terms element #{dct_element}" do
            expect(solr_doc.keys).to include dct_element
          end
        end
      end

      context "for all elements within the layer namespace" do

        %w{ georss_point_s }.each do |geo_rss_element|
          
          it "indexes the GeoRSS element #{geo_rss_element}" do
            expect(solr_doc.keys).to include geo_rss_element
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

    it 'has standard' do
      expect(subject).to respond_to(:conforms_to)
    end
  end
end
