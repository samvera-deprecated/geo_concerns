require 'rails_helper'

describe GeoConcerns::Coverage do
  subject { GeoConcerns::Coverage } # prevent instantiation

  it 'should parse integers' do
    coverage = subject.parse('northlimit=1; eastlimit=2; southlimit=-3; westlimit=-4;')
    expect(coverage.n).to eq(1)
    expect(coverage.e).to eq(2)
    expect(coverage.s).to eq(-3)
    expect(coverage.w).to eq(-4)
  end

  it 'should parse floats' do
    coverage = subject.parse('northlimit=1.0; eastlimit=-2; southlimit=-3.33; westlimit=-4.1;')
    expect(coverage.n).to eq(1.0)
    expect(coverage.e).to eq(-2)
    expect(coverage.s).to eq(-3.33)
    expect(coverage.w).to eq(-4.1)
  end

  it 'should render integers' do
    coverage = subject.new(1, 2, -3, -4)
    expect(coverage.to_s).to match /^northlimit=1; eastlimit=2; southlimit=-3; westlimit=-4;/
  end

  it 'should render floats' do
    coverage = subject.new(1.0, -2, -3.33, -4.1)
    expect(coverage.to_s).to match /^northlimit=1.0; eastlimit=-2; southlimit=-3.33; westlimit=-4.1;/
  end

  it 'should include units and projection' do
    coverage = subject.new(1, 2, -3, -4)
    expect(coverage.to_s).to match /units=degrees; projection=EPSG:4326$/
  end

  it 'should fail parsing gracefully' do
    expect { subject.parse('bogus') }.to raise_error(GeoConcerns::Coverage::ParseError)
  end

  it 'should fail broken geometries gracefully' do
    expect { subject.new(1, 2, 3, -4) }.to raise_error(GeoConcerns::Coverage::InvalidGeometryError)
    expect { subject.new(1, 2, -3, 4) }.to raise_error(GeoConcerns::Coverage::InvalidGeometryError)
  end
end
