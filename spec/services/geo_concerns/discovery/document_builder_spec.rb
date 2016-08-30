require 'spec_helper'

# See https://github.com/geoblacklight/geoblacklight/wiki/Schema

describe GeoConcerns::Discovery::DocumentBuilder do
  subject { described_class.new(geo_concern_presenter, document_class) }

  let(:geo_concern) { FactoryGirl.build(:public_vector_work, attributes) }
  let(:geo_concern_presenter) { GeoConcerns::VectorWorkShowPresenter.new(SolrDocument.new(geo_concern.to_solr), nil) }
  let(:document_class) { GeoConcerns::Discovery::GeoblacklightDocument.new }
  let(:document) { JSON.parse(subject.to_json(nil)) }
  let(:metadata__mime_type) { 'application/xml; schema=iso19139' }
  let(:metadata_file) { FileSet.new(id: 'metadatafile', geo_mime_type: metadata__mime_type) }
  let(:metadata_presenter) { CurationConcerns::FileSetPresenter.new(SolrDocument.new(metadata_file.to_solr), nil) }
  let(:geo_file_mime_type) { 'application/zip; ogr-format="ESRI Shapefile"' }
  let(:geo_file) { FileSet.new(id: 'geofile', geo_mime_type: geo_file_mime_type) }
  let(:geo_file_presenter) { CurationConcerns::FileSetPresenter.new(SolrDocument.new(geo_file.to_solr), nil) }
  let(:coverage) { GeoConcerns::Coverage.new(43.039, -69.856, 42.943, -71.032) }
  let(:issued) { '01/02/2013' }
  let(:issued_xmlschema) { '2013-02-01T00:00:00Z' }
  let(:attributes) { { id: 'geo-work-1',
                       title: ['Geo Work'],
                       coverage: coverage.to_s,
                       description: ['This is a Geo Work'],
                       creator: ['Yosiwo George'],
                       publisher: ['National Geographic'],
                       issued: issued,
                       spatial: ['Micronesia'],
                       temporal: ['2011'],
                       subject: ['Human settlements'],
                       provenance: 'Pacific Islands University',
                       language: ['Esperanto'] }
  }

  describe 'vector work' do
    before do
      allow(geo_concern_presenter).to receive(:file_set_presenters).and_return([geo_file_presenter, metadata_presenter])
    end

    context 'required' do
      it 'has all metadata' do
        expect(document['dc_identifier_s']).to eq('geo-work-1')
        expect(document['layer_slug_s']).to eq('pacific-islands-university-geo-work-1')
        expect(document['dc_title_s']).to eq('Geo Work')
        expect(document['solr_geom']).to eq('ENVELOPE(-71.032, -69.856, 43.039, 42.943)')
        expect(document['dct_provenance_s']).to eq('Pacific Islands University')
        expect(document['dc_rights_s']).to eq('Restricted')
        expect(document['geoblacklight_version']).to eq('1.0')
      end
    end

    context 'optional' do
      it 'has metadata' do
        expect(document['dc_description_s']).to eq('This is a Geo Work')
        expect(document['dc_creator_sm']).to eq(['Yosiwo George'])
        expect(document['dc_subject_sm']).to eq(['Human settlements'])
        expect(document['dct_spatial_sm']).to eq(['Micronesia'])
        expect(document['dct_temporal_sm']).to eq(['2011'])
        expect(document['dc_language_s']).to eq('Esperanto')
        expect(document['dc_publisher_s']).to eq('National Geographic')
      end

      it 'has modified date' do
        expect(document).to include('layer_modified_dt')
        # TODO: Rails 4 puts +00:00 rather than Z for `xmlschema` format
        expect(document['layer_modified_dt']).to match(/\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d(Z|\+00:00)/)
      end

      context 'issued date' do
        it 'works with valid date' do
          expect(document).to include('dct_issued_dt')
          expect(document['dct_issued_dt']).to eq(issued_xmlschema)
        end
      end

      it 'has date field' do
        expect(document['solr_year_i']).to eq(2011)
      end

      it 'has layer info fields' do
        expect(document['layer_geom_type_s']).to eq('Mixed')
        expect(document['dc_format_s']).to eq('Shapefile')
      end

      it 'has references' do
        refs = JSON.parse(document['dct_references_s'])
        expect(refs['http://schema.org/url']).to eq('http://localhost:3000/concern/vector_works/geo-work-1')
        expect(refs['http://www.isotc211.org/schemas/2005/gmd/']).to eq('http://localhost:3000/downloads/metadatafile')
        expect(refs['http://schema.org/downloadUrl']).to eq('http://localhost:3000/downloads/geofile')
        expect(refs['http://schema.org/thumbnailUrl']).to eq('http://localhost:3000/downloads/geofile?file=thumbnail')
      end
    end
  end

  describe 'raster work' do
    let(:geo_concern_presenter) { GeoConcerns::RasterWorkShowPresenter.new(SolrDocument.new(geo_concern.to_solr), nil) }

    context 'with a GeoTIFF file and a FGDC metadata file' do
      let(:geo_file_mime_type) { 'image/tiff; gdal-format=GTiff' }
      let(:metadata__mime_type) { 'application/xml; schema=fgdc' }

      before do
        allow(geo_concern_presenter).to receive(:file_set_presenters).and_return([geo_file_presenter, metadata_presenter])
      end

      it 'has layer info fields' do
        expect(document['layer_geom_type_s']).to eq('Raster')
        expect(document['dc_format_s']).to eq('GeoTIFF')
      end

      it 'has references' do
        refs = JSON.parse(document['dct_references_s'])
        expect(refs['http://www.opengis.net/cat/csw/csdgm']).to eq('http://localhost:3000/downloads/metadatafile')
      end
    end

    context 'with an ArcGRID file and a MODS metadata file' do
      let(:geo_file_mime_type) { 'application/octet-stream; gdal-format=AIG' }
      let(:metadata__mime_type) { 'application/mods+xml' }

      before do
        allow(geo_concern_presenter).to receive(:file_set_presenters).and_return([geo_file_presenter, metadata_presenter])
      end

      it 'has layer info fields' do
        expect(document['dc_format_s']).to eq('ArcGRID')
      end

      it 'has references' do
        refs = JSON.parse(document['dct_references_s'])
        expect(refs['http://www.loc.gov/mods/v3']).to eq('http://localhost:3000/downloads/metadatafile')
      end
    end
  end

  describe 'image work' do
    let(:geo_concern_presenter) { GeoConcerns::ImageWorkShowPresenter.new(SolrDocument.new(geo_concern.to_solr), nil) }

    context 'with a tiff file and no decription' do
      let(:geo_file_mime_type) { 'image/tiff' }

      before do
        attributes.delete(:description)
        allow(geo_concern_presenter).to receive(:file_set_presenters).and_return([geo_file_presenter, metadata_presenter])
      end

      it 'uses a default description' do
        expect(document['dc_description_s']).to eq('A vector work object.')
      end

      it 'has layer info fields' do
        expect(document['layer_geom_type_s']).to eq('Scanned Map')
        expect(document['dc_format_s']).to eq('TIFF')
      end
    end
  end

  context 'with a missing required metadata field' do
    before do
      attributes.delete(:title)
      allow(geo_concern_presenter).to receive(:file_set_presenters).and_return([geo_file_presenter, metadata_presenter])
    end

    it 'returns an error document' do
      expect(document['error'][0]).to include('dc_title_s')
      expect(document['error'].size).to eq(1)
    end
  end

  context 'with a missing non-required metadata field' do
    before do
      attributes.delete(:language)
      allow(geo_concern_presenter).to receive(:file_set_presenters).and_return([geo_file_presenter, metadata_presenter])
    end

    it 'returns a document without the field but valid' do
      expect(document['dc_language_s']).to be_nil
    end
  end

  context 'with a public visibility' do
    before do
      viz = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      allow(geo_concern_presenter).to receive(:file_set_presenters).and_return([geo_file_presenter, metadata_presenter])
      allow(geo_concern_presenter.solr_document).to receive(:visibility).and_return(viz)
    end

    it 'return a public access' do
      expect(document['dc_rights_s']).to eq('Public')
    end
  end

  context 'with ssl enabled' do
    subject { described_class.new(geo_concern_presenter, document_class, ssl: true) }

    before do
      allow(geo_concern_presenter).to receive(:file_set_presenters).and_return([geo_file_presenter, metadata_presenter])
    end

    it 'returns https reference urls' do
      refs = JSON.parse(document['dct_references_s'])
      expect(refs['http://schema.org/url']).to eq('https://localhost:3000/concern/vector_works/geo-work-1')
    end
  end
end
