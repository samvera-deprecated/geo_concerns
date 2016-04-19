require 'rails_helper'

describe GeoConcerns::Coverage do
  subject { described_class } # prevent instantiation

  it 'parses integers' do
    coverage = subject.parse('northlimit=1; eastlimit=2; southlimit=-3; westlimit=-4;')
    expect(coverage.n).to eq(1)
    expect(coverage.e).to eq(2)
    expect(coverage.s).to eq(-3)
    expect(coverage.w).to eq(-4)
  end

  it 'parses floats' do
    coverage = subject.parse('northlimit=1.0; eastlimit=-2; southlimit=-3.33; westlimit=-4.1;')
    expect(coverage.n).to eq(1.0)
    expect(coverage.e).to eq(-2)
    expect(coverage.s).to eq(-3.33)
    expect(coverage.w).to eq(-4.1)
  end

  it 'renders integers' do
    coverage = subject.new(1, 2, -3, -4)
    expect(coverage.to_s).to match(/^northlimit=1; eastlimit=2; southlimit=-3; westlimit=-4;/)
  end

  it 'renders floats' do
    coverage = subject.new(1.0, -2, -3.33, -4.1)
    expect(coverage.to_s).to match(/^northlimit=1.0; eastlimit=-2; southlimit=-3.33; westlimit=-4.1;/)
  end

  it 'includes units and projection' do
    coverage = subject.new(1, 2, -3, -4)
    expect(coverage.to_s).to match(/units=degrees; projection=EPSG:4326$/)
  end

  it 'fails parsing gracefully' do
    expect { subject.parse('bogus') }.to raise_error(GeoConcerns::Coverage::ParseError)
  end

  it 'fails broken geometries gracefully' do
    expect { subject.new(1, 2, 3, -4) }.to raise_error(GeoConcerns::Coverage::InvalidGeometryError)
    expect { subject.new(1, 2, -3, 4) }.to raise_error(GeoConcerns::Coverage::InvalidGeometryError)
  end

  it 'formats values as WKT feature envelopes' do
    coverage = subject.new(1.0, -2.0, -3.33, -4.1)
    expect(coverage.to_envelope).to eq('ENVELOPE(1.0, -2.0, -3.33, -4.1)')
  end
end
