require 'spec_helper'

describe GeoConcerns::DerivativePath do
  describe '#extension' do
    it 'returns the appropriate file extension for a geo derivative' do
      expect(described_class.extension('thumbnail')).to eq('.jpeg')
      expect(described_class.extension('display_raster')).to eq('.tif')
      expect(described_class.extension('display_vector')).to eq('.zip')
      expect(described_class.extension('simplified')).to eq('.simplified')
    end
  end
end
