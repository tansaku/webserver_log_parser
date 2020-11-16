# frozen_string_literal: true

require 'web_page_visits'

describe WebPageVisits do
  let(:ip1) { '126.318.035.038' }
  let(:ip2) { '126.318.035.039' }
  let(:visits_home) { described_class.new('/home', [ip1, ip1]) }
  let(:visits_about) { described_class.new('/about', [ip2]) }
  subject(:visits_array) { [visits_about, visits_home] }

  it 'should sort by number of ips by default' do
    expect(visits_array.sort.reverse).to eq [visits_home, visits_about]
  end

  it 'should present itself clearly' do
    expect(visits_home.to_s).to eq '/home 2 visits'
  end

  it 'should present unique visits clearly' do
    expect(visits_home.to_s(:unique_number)).to eq '/home 1 visit'
  end

  it 'can have different ips added over time' do
    visits_about.add(ip1)
    expect(visits_about.to_s(:unique_number)).to eq '/about 2 visits'
    expect(visits_about.to_s(:number)).to eq '/about 2 visits'
  end

  it 'can have the same ips added over time' do
    visits_about.add(ip2)
    expect(visits_about.to_s(:unique_number)).to eq '/about 1 visit'
    expect(visits_about.to_s(:number)).to eq '/about 2 visits'
  end

  it 'rejects to_s arg other than number or unique_number features' do
    expect { visits_home.to_s(:hack) }.to raise_error WebPageVisits::ERROR
  end
end
