require 'spec_helper'

describe GeoConcerns::Processors::ProjectData do
  let(:output_file) { double }
  let(:file_name) { double }

  subject { described_class.new(file_name, directives) }

  before do
    allow(subject).to receive(:output_file).with(file_name).and_return(output_file)
  end

  describe "for Shapefiles" do
    let(:directives) { { format: 'ESRI Shapefile' } }
    let(:file_name) { 'spec/fixtures/McKay/S_566_1914_lines.shp' }

    it "will fire a Shapefile reprojection" do
      expect { subject.process }.not_to raise_error
    end
  end

  describe "for GeoTIFF" do
    let(:directives) { { format: 'GTiff' } }
    let(:file_name) { 'spec/fixtures/BackscatterA_8101_OffshoreBodegaHead.tif' }

    it "will fire a GeoTIFF reprojection" do
      expect { subject.process }.not_to raise_error
    end
  end

  describe "for unknown formats" do
    let(:directives) { { format: 'UNKNOWN' } }
    let(:file_name) { 'noname' }

    it "will throw an error for unknown formats" do
      expect { subject.process }.to raise_error(NotImplementedError)
    end
  end
end
