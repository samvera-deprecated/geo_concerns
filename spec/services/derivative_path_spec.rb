require 'spec_helper'

describe GeoConcerns::DerivativePath do
  describe '#extension_for' do
    it 'returns the appropriate file extension for a geo derivative' do
      expect(described_class.extension_for('thumbnail')).to eq('.jpeg')
      expect(described_class.extension_for('display_raster')).to eq('.tif')
      expect(described_class.extension_for('display_vector')).to eq('.zip')
      expect(described_class.extension_for('simplified')).to eq('.simplified')
    end
  end
end
