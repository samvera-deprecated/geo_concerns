require 'spec_helper'

describe FileSet do
  let(:user) { create(:user) }
  subject { described_class.new(mime_type: 'application/zip; ogr-format="ESRI Shapefile"') }

  context "when mime_type is a vector format" do
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
                                       date_uploaded: Time.zone.today,
                                       cartographic_projection: 'urn:ogc:def:crs:EPSG::6326').to_solr
    }

    it "indexes the coordinate reference system" do
      expect(solr_doc.keys).to include 'cartographic_projection_tesim'
    end

    context "as required by the GeoBlacklight Schema" do
      it "indexes the UUID" do
        expect(solr_doc.keys).to include 'uuid'
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
      expect(subject).to respond_to(:mime_type)
    end
  end
end
