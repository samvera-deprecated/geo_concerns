require 'rails_helper'

describe CurationConcerns::BasicGeoMetadataForm do
  before do
    class TestModel < ActiveFedora::Base
      property :coverage, predicate: ::RDF::Vocab::DC11.coverage, multiple: false
    end

    class TestForm < CurationConcerns::Forms::WorkForm
      include CurationConcerns::BasicGeoMetadataForm
      self.model_class = TestModel
    end
  end

  after do
    Object.send(:remove_const, :TestForm)
    Object.send(:remove_const, :TestModel)
  end

  let(:object) { TestModel.new(coverage: 'northlimit=43.039; eastlimit=-69.856; southlimit=42.943; westlimit=-71.032; units=degrees; projection=EPSG:4326') }
  let(:form) { TestForm.new(object, nil) }

  describe '.terms' do
    subject { form.terms }
    it { is_expected.to include(:coverage) }
  end
end
