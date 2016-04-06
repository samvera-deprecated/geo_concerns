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
      allow(subject).to receive(:mime_type).and_return('application/xml; schema=iso19139')
    end
    it 'is true' do
      expect(subject.external_metadata_file?).to be true
    end
  end
end
