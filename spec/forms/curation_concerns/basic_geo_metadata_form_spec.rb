require 'rails_helper'

describe CurationConcerns::BasicGeoMetadataForm do
  before do
    class TestModel < ActiveFedora::Base
      property :bounding_box,
               predicate: ::RDF::URI.new('http://www.georss.org/georss/box'),
               multiple: false
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

  let(:object) { TestModel.new(bounding_box: '42.943 -71.032 43.039 -69.856') }
  let(:form) { TestForm.new(object, nil) }

  describe '.terms' do
    subject { form.terms }
    it { is_expected.to include(:bounding_box) }
  end
end
