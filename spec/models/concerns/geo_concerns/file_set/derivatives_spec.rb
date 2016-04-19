require 'spec_helper'

shared_examples 'a set of raster derivatives' do
  it 'makes a thumbnail' do
    new_thumb = "#{Rails.root}/tmp/derivatives/#{file_set.id}/thumbnail.thumbnail"
    expect {
      file_set.create_derivatives(file_name)
    }.to change { Dir[new_thumb].empty? }
      .from(true).to(false)
  end

  it 'makes a display raster' do
    new_thumb = "#{Rails.root}/tmp/derivatives/#{file_set.id}/display_raster.display_raster"
    expect {
      file_set.create_derivatives(file_name)
    }.to change { Dir[new_thumb].empty? }
      .from(true).to(false)
  end
end

shared_examples 'a set of vector derivatives' do
  it 'makes a thumbnail' do
    new_thumb = "#{Rails.root}/tmp/derivatives/#{file_set.id}/thumbnail.thumbnail"
    expect {
      file_set.create_derivatives(file_name)
    }.to change { Dir[new_thumb].empty? }
      .from(true).to(false)
  end

  it 'makes a display vector' do
    new_thumb = "#{Rails.root}/tmp/derivatives/#{file_set.id}/display_vector.display_vector"
    expect {
      file_set.create_derivatives(file_name)
    }.to change { Dir[new_thumb].empty? }
      .from(true).to(false)
  end
end

describe CurationConcerns::FileSet do
  let(:file_set) { FileSet.create { |gf| gf.apply_depositor_metadata('geonerd@example.com') } }

  before do
    allow(file_set).to receive(:mime_type).and_return(mime_type)

    allow(CurationConcerns::DerivativePath).to receive(:derivative_path_for_reference) do |object, key|
      "#{Rails.root}/tmp/derivatives/#{object.id}/#{key}.#{key}"
    end
  end

  after do
    dir = File.join(CurationConcerns.config.derivatives_path, file_set.id)
    FileUtils.rm_r(dir) if File.directory?(dir)
  end

  describe 'geo derivatives' do
    describe 'vector processing' do
      context 'with a shapefile' do
        let(:mime_type) { 'application/zip; ogr-format="ESRI Shapefile"' }
        let(:file_name) { File.join(fixture_path, 'files', 'tufts-cambridgegrid100-04.zip') }
        it_behaves_like 'a set of vector derivatives'
      end

      context 'with a geojson file' do
        let(:mime_type) { 'application/vnd.geo+json' }
        let(:file_name) { File.join(fixture_path, 'files', 'mercer.json') }
        it_behaves_like 'a set of vector derivatives'
      end
    end

    describe 'raster processing' do
      context 'with a geo tiff file' do
        let(:mime_type) { 'image/tiff; gdal-format=GTiff' }
        let(:file_name) { File.join(fixture_path, 'files', 'S_566_1914_clip.tif') }
        it_behaves_like 'a set of raster derivatives'
      end

      context 'with a usgs ascii dem file' do
        let(:mime_type) { 'text/plain; gdal-format=USGSDEM' }
        let(:file_name) { File.join(fixture_path, 'files', 'shandaken_clip.dem') }
        it_behaves_like 'a set of raster derivatives'
      end

      context 'with an arc/info binary grid file' do
        let(:mime_type) { 'application/octet-stream; gdal-format=AIG' }
        let(:file_name) { File.join(fixture_path, 'files', 'precipitation.zip') }
        it_behaves_like 'a set of raster derivatives'
      end
    end
  end
end
