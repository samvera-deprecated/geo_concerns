require 'spec_helper'

describe GeoConcerns::RasterFormatService do
  subject { described_class }

  it 'has select_options' do
    expect(subject.select_options).to eq([['GeoTIFF', 'image/tiff; gdal-format=GTiff'], ['Arc/Info ASCII Grid', 'text/plain; gdal-format=AAIGrid'], ['Arc/Info Binary Grid', 'application/octet-stream; gdal-format=AIG'], ['USGS ASCII DEM', 'text/plain; gdal-format=USGSDEM']])
  end

  it 'looks up a label for a term' do
    expect(subject.label('image/tiff; gdal-format=GTiff')).to eq('GeoTIFF')
  end
end
