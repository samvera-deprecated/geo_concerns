require 'spec_helper'

describe GeoConcerns::Processors::Image do
  before do
    class TestProcessor
      include GeoConcerns::Processors::Image
    end
  end

  after { Object.send(:remove_const, :TestProcessor) }

  subject { TestProcessor.new }

  let(:output_file_jpg) { 'output/geo.jpg' }
  let(:output_file_png) { 'output/geo.png' }
  let(:output_file) { output_file_png }
  let(:file_name) { 'files/geo.tif' }
  let(:options) { { output_size: '150 150' } }

  describe '#convert' do
    let(:image) { double }

    before do
      allow(MiniMagick::Image).to receive(:open).and_return(image)
    end

    it 'transforms the image and saves it as a PNG' do
      expect(image).to receive(:format).with('png')
      expect(image).to receive(:combine_options)
      expect(image).to receive(:write).with(output_file_png)
      subject.class.convert(file_name, output_file_png, options)
    end

    it 'transforms the image and saves it as a JPG' do
      expect(image).to receive(:format).with('jpg')
      expect(image).to receive(:combine_options)
      expect(image).to receive(:write).with(output_file_jpg)
      subject.class.convert(file_name, output_file_jpg, options)
    end
  end

  describe '#trim' do
    let(:shell) { double }
    let(:args) { [["convert", "files/geo.tif", "-trim", "output/geo.png"], { whiny: true }] }

    before do
      allow(MiniMagick::Shell).to receive(:new).and_return(shell)
    end
    it 'transforms the image and saves it as a PNG' do
      expect(shell).to receive(:run).with(*args).and_return('output message')
      subject.class.trim(file_name, output_file_png, options)
    end
  end

  describe '#center' do
    let(:shell) { double }
    let(:args) {
      [['convert', '-size', '150x150', 'xc:white', 'files/geo.tif',
        '-gravity', 'center', '-composite', 'output/geo.png'],
       { whiny: true }]
    }

    before do
      allow(MiniMagick::Shell).to receive(:new).and_return(shell)
    end
    it 'transforms the image and saves it as a PNG' do
      expect(shell).to receive(:run).with(*args).and_return('output message')
      subject.class.center(file_name, output_file_png, options)
    end
  end
end
