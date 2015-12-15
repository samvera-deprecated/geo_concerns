require 'rails_helper'

describe CurationConcerns::ImageWorksController do
  describe "#show_presenter" do
    it "is a image work show presenter" do
      expect(CurationConcerns::ImageWorksController.new.show_presenter).to eq(ImageWorkShowPresenter)
    end
  end
end
