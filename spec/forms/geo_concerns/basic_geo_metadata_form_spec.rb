require 'spec_helper'

describe GeoConcerns::BasicGeoMetadataForm do
  before do
    class TestModel < ActiveFedora::Base
      property :coverage, predicate: ::RDF::Vocab::DC11.coverage, multiple: false
    end

    class TestForm < CurationConcerns::Forms::WorkForm
      include GeoConcerns::BasicGeoMetadataForm
      self.model_class = TestModel
    end
  end

  after do
    Object.send(:remove_const, :TestForm)
    Object.send(:remove_const, :TestModel)
  end

  let(:object) { TestModel.new(coverage: GeoConcerns::Coverage.new(43.039, -69.856, 42.943, -71.032).to_s) }
  let(:form) { TestForm.new(object, nil) }

  describe '.terms' do
    subject { form.terms }
    it { is_expected.to include(:coverage) }
  end
end
