# frozen_string_literal: true

require 'most_viewed_pages'

describe MostViewedPages do
  let(:log_entry_1) { '/help_page/1 126.318.035.038' }
  let(:log_entry_2) { '/contact 184.123.665.067' }
  subject(:most_viewed_pages) { described_class }

  it 'returns most page views for single log entry' do
    allow(File).to receive(:readlines).and_return([log_entry_1])
    expect(most_viewed_pages.list).to eq "/help_page/1 1 visit\n"
  end

  it 'returns most page views for multiple log entries' do
    result = "/help_page/1 1 visit\n/contact 1 visit\n"
    allow(File).to receive(:readlines).and_return([log_entry_1, log_entry_2])
    expect(most_viewed_pages.list).to eq result
  end

  it 'returns most page views for multiple log entries' do
    result = "/help_page/1 1 visit\n/contact 2 visits\n"
    log = [log_entry_1, log_entry_2, log_entry_2]
    allow(File).to receive(:readlines).and_return(log)
    expect(most_viewed_pages.list).to eq result
  end
end
