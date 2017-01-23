require 'spec_helper'

describe GeoConcerns::Discovery::DocumentBuilder::Wxs do
  subject { described_class.new(geo_concern_presenter) }

  let(:geo_concern) { FactoryGirl.build(:public_vector_work, id: 'geo-work-1') }
  let(:geo_concern_presenter) { GeoConcerns::VectorWorkShowPresenter.new(SolrDocument.new(geo_concern.to_solr), nil) }
  let(:geo_file_mime_type) { 'application/zip; ogr-format="ESRI Shapefile"' }
  let(:geo_file) { FileSet.new(id: 'geofile', geo_mime_type: geo_file_mime_type) }
  let(:geo_file_presenter) { CurationConcerns::FileSetPresenter.new(SolrDocument.new(geo_file.to_solr), nil) }
  let(:visibility) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }

  before do
    allow(geo_file_presenter.solr_document).to receive(:visibility).and_return(visibility)
    allow(geo_concern_presenter).to receive(:member_presenters).and_return([geo_file_presenter])
  end

  describe '#identifier' do
    context 'public document' do
      it 'returns a public identifier' do
        expect(subject.identifier).to eq 'public:geofile'
      end
    end

    context 'private document' do
      let(:visibility) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE }
      it 'returns a the fileset id' do
        expect(subject.identifier).to eq 'geofile'
      end
    end
  end

  describe '#wms_path' do
    context 'public document' do
      it 'returns a public wms path' do
        expect(subject.wms_path).to eq 'http://localhost:8181/geoserver/public/wms'
      end
    end

    context 'restricted document' do
      let(:visibility) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }
      it 'returns a restricted value' do
        expect(subject.wms_path).to eq 'http://localhost:8181/geoserver/restricted/wms'
      end
    end

    context 'private document' do
      let(:visibility) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE }
      it 'returns a nil value' do
        expect(subject.wms_path).to be_nil
      end
    end
  end

  describe '#wfs_path' do
    context 'public document' do
      let(:visibility) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
      it 'returns a valid wms path' do
        expect(subject.wfs_path).to eq 'http://localhost:8181/geoserver/public/wfs'
      end
    end

    context 'private document' do
      let(:visibility) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE }
      it 'returns a nil value' do
        expect(subject.wfs_path).to be_nil
      end
    end
  end
end
