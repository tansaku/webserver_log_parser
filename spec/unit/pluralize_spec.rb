# frozen_string_literal: true

require 'pluralize'
describe Pluralize do
  it 'correctly presents singular form' do
    expect(Pluralize.format(1, 'visit')).to eq '1 visit'
  end

  it 'correctly presents default plural form' do
    expect(Pluralize.format(6, 'visit')).to eq '6 visits'
  end

  it 'correctly presents plural form for exceptions' do
    expect(Pluralize.format(6, 'sheep', 'sheep')).to eq '6 sheep'
  end
end
