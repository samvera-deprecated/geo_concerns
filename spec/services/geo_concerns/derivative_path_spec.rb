require 'spec_helper'

describe GeoConcerns::DerivativePath do
  subject { described_class.derivative_path_for_reference('12', destination_name) }
  describe '#extension' do
    context 'with thumbnail destination' do
      let(:destination_name) { 'thumbnail' }
      it { is_expected.to include('.jpeg') }
    end

    context 'with display_raster destination' do
      let(:destination_name) { 'display_raster' }
      it { is_expected.to include('.tif') }
    end

    context 'with display_vector destination' do
      let(:destination_name) { 'display_vector' }
      it { is_expected.to include('.zip') }
    end

    context 'with simplified destination' do
      let(:destination_name) { 'simplified' }
      it { is_expected.to include('.simplified') }
    end
  end
end
