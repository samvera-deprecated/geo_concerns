require 'spec_helper'

describe GeoConcerns::GeoWorksHelper do
  let(:helper) { TestingHelper.new }
  let(:presenter) { instance_double('Presenter', class: GeoConcerns::ImageWorkShowPresenter) }
  before do
    class TestingHelper
      include GeoConcerns::GeoWorksHelper
    end
  end
  after do
    Object.send(:remove_const, :TestingHelper)
  end

  describe '#child_geo_works_type' do
    it 'returns a the child work type name' do
      expect(helper.child_geo_works_type(presenter)).to eq 'Raster'
    end
  end

  describe '#geo_work_type' do
    before do
      allow(presenter).to receive(:human_readable_type).and_return('ImageWork')
    end

    it 'returns a the work type name' do
      expect(helper.geo_work_type(presenter)).to eq 'Image'
    end
  end
end
