require 'spec_helper'

describe FileSet do
  let(:user) { create(:user) }

  it 'is a Hydra::Works::FileSet' do
    expect(subject).to be_file_set
  end
end
