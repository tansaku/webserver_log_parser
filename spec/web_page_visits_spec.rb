# frozen_string_literal: true

require 'web_page_visits'

describe WebPageVisits do
  let(:ip) { '126.318.035.038' }
  let(:visits_home) { described_class.new('/home', [ip, ip]) }
  let(:visits_about) { described_class.new('/about', [ip]) }
  subject(:visits_array) { [visits_about, visits_home] }
  it 'should sort by number of ips by default' do
    expect(visits_array.sort.reverse).to eq [visits_home, visits_about]
  end
end
