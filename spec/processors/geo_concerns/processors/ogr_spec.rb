require 'spec_helper'

describe GeoConcerns::Processors::BaseGeoProcessor do
  before do
    class TestProcessor
      include Hydra::Derivatives::Processors::ShellBasedProcessor
      include GeoConcerns::Processors::Ogr
      def directives
      end

      def source_path
      end
    end

    allow(subject).to receive(:directives).and_return(directives)
    allow(subject).to receive(:source_path).and_return(file_name)
  end

  after { Object.send(:remove_const, :TestProcessor) }

  subject { TestProcessor.new }

  let(:directives) { { format: 'png', size: '200x400' } }
  let(:output_file) { 'output/geo.png' }
  let(:file_name) { 'files/geo.zip' }
  let(:options) { { output_size: '150 150', output_srid: 'EPSG:4326' } }

  describe '#reproject' do
    it 'executes a reproject command' do
      command = "env SHAPE_ENCODING= ogr2ogr -q -nln  -f 'ESRI Shapefile' "\
                  "-t_srs EPSG:4326 -preserve_fid 'output/geo.png' 'files/geo.zip'"
      expect(subject.class).to receive(:execute).with command
      subject.class.reproject(file_name, output_file, options)
    end
  end
end
