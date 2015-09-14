require 'spec_helper'

# This tests the Image model. It includes the ImageBehavior module and nothing else.
# So this test covers both the ImageBehavior module and the generated Image model
describe Image do
  let(:user) { FactoryGirl.find_or_create(:jill) }

  it 'updates the title' do
    subject.attributes = { title: ['An image work'] }
    expect(subject.title).to eq(['An image work'])
  end

  describe 'metadata' do
    it 'has descriptive metadata' do
      expect(subject).to respond_to(:title)
    end
  end

  context 'with a single image bitstream' do
    subject { FactoryGirl.create(:image_with_one_file, title: ['Test title 3']) }

    it 'has one file' do
      expect(subject.image_file).to be_kind_of ImageFile
    end
  end

  context 'with georectified rasters' do
    subject { FactoryGirl.create(:image_with_rasters, title: ['Test title 4']) }

    it 'has one or many rasters' do
      expect(subject.rasters.size).to eq 2
      expect(subject.rasters.first).to be_kind_of Raster
    end
  end
end
