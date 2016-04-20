require 'spec_helper'

describe GeoConcerns::GeoreferencedForm do
  before do
    class TestModel < ActiveFedora::Base
      property :cartographic_projection,
               predicate: ::RDF::URI.new('http://bibframe.org/vocab/cartographicProjection'),
               multiple: false
    end

    class TestForm < CurationConcerns::Forms::WorkForm
      include GeoConcerns::GeoreferencedForm
      self.model_class = TestModel
    end
  end

  after do
    Object.send(:remove_const, :TestForm)
    Object.send(:remove_const, :TestModel)
  end

  let(:object) { TestModel.new(cartographic_projection: 'urn:ogc:def:crs:EPSG:6.3:26986') }
  let(:form) { TestForm.new(object, nil) }

  describe '.terms' do
    subject { form.terms }
    it { is_expected.to include(:cartographic_projection) }
  end
end
