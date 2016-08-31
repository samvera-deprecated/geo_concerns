require 'spec_helper'

describe GeoConcerns::CoverageRenderer do
  let(:coverage) { 'northlimit=2.7; eastlimit=4.0; southlimit=1.3; westlimit=2.9; units=degrees; projection=EPSG:4326' }
  let(:renderer) { described_class.new(:coverage, [coverage]) }
  subject { renderer.render }

  it 'includes the coverage string' do
    expect(subject).to include coverage
  end

  it 'includes a map' do
    expect(subject).to include "<div id='bbox'"
    expect(subject).to include "boundingBoxSelector"
  end

  it 'includes a toggle button' do
    expect(subject).to include "<a data-toggle='collapse' data-parent='accordion' href='#bbox'"
    expect(subject).to include "Toggle Map"
  end
end
