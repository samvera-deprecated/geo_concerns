require 'spec_helper'

describe GeoFileFormatBehavior do
  subject { FileSet.new }

  describe '#image_file?' do
    before do
      allow(subject).to receive(:mime_type).and_return('image/tiff')
    end
    it 'is true' do
      expect(subject.image_file?).to be true
    end
  end

  describe '#raster_file?' do
    before do
      allow(subject).to receive(:mime_type).and_return('image/tiff; gdal-format=GTiff')
    end
    it 'is true' do
      expect(subject.raster_file?).to be true
    end
  end

  describe '#vector_file?' do
    before do
      allow(subject).to receive(:mime_type).and_return('application/zip; ogr-format="ESRI Shapefile"')
    end
    it 'is true' do
      expect(subject.vector_file?).to be true
    end
  end

  describe '#external_metadata_file?' do
    before do
      allow(subject).to receive(:conforms_to).and_return('ISO19139')
    end
    it 'is true' do
      expect(subject.external_metadata_file?).to be true
    end
  end

  describe '#gdal_formats' do
    it 'returns array of raster formats' do
      expect(subject.class.gdal_formats).to include('image/tiff; gdal-format=GTiff')
    end
  end

  describe '#ogr_formats' do
    it 'returns array of vector formats' do
      expect(subject.class.ogr_formats).to include('application/zip; ogr-format="ESRI Shapefile"')
    end
  end

  describe '#metadata_standards' do
    it 'returns array of external metadata file formats' do
      expect(subject.class.metadata_standards).to eq(['FGDC', 'ISO19139', 'MODS'])
    end
  end
end
