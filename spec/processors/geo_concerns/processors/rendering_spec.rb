require 'spec_helper'

describe GeoConcerns::Processors::Rendering do
  before do
    class TestProcessor
      include GeoConcerns::Processors::Rendering
    end
  end

  after { Object.send(:remove_const, :TestProcessor) }

  subject { TestProcessor.new }

  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files' }
  let(:options) { { output_size: '150 200' } }
  let(:bounds) { { north: 40.0, east: -74.0, south: 40.0, west: -74.0 } }
  let(:info) { instance_double(GeoConcerns::Processors::Vector::Info, name: 'test', bounds: bounds) }
  let(:config) {
    {
      'stroke' => '#483d8b',
      'line-cap' => 'square',
      'line-join' => 'miter',
      'weight' => '0.3',
      'fill' => '#e4e3ea',
      'radius' => '2'
    }
  }

  before do
    allow(GeoConcerns::Processors::Vector::Info).to receive(:new).and_return(info)
    allow(SimplerTiles.config).to receive(:to_h).and_return(config)
    allow(SimplerTiles.config).to receive(:bg_color).and_return('#ffffff00')
    allow(Dir).to receive(:glob).and_return(['test.shp'])
  end

  describe '#vector_thumbnail' do
    it 'saves a vector thumbnail using simpler tiles' do
      expect(File).to receive(:open).with(output_file, 'wb')
      subject.class.vector_thumbnail(file_name, output_file, options)
    end
  end

  describe '#simple_tiles_map' do
    subject { described_class.simple_tiles_map(file_name, options) }

    it 'has a background color' do
      expect(subject.bgcolor).to eq('#ffffff00')
    end

    it 'has a valid bounds property' do
      expect(subject.bounds.to_wkt).to match(/-74.000000 40.000000/)
    end

    it 'has the correct width and height' do
      expect(subject.width).to eq(150)
      expect(subject.height).to eq(200)
    end

    it 'has a WGS 84 projection' do
      expect(subject.srs).to eq('+proj=longlat +datum=WGS84 +no_defs ')
    end
  end
end
