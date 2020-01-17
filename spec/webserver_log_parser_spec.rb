# frozen_string_literal: true

require 'webserver_log_parser'

describe WebserverLogParser do
  let(:log_entry_1) { '/help_page/1 126.318.035.038' }
  let(:log_entry_2) { '/contact 184.123.665.067' }
  subject(:parser) { described_class.parse }

  it 'returns most page views for single log entry' do
    allow(File).to receive(:readlines).and_return([log_entry_1])
    expect(parser.most_page_views).to eq "/help_page/1 1 visit\n"
  end

  it 'returns most page views for multiple log entries' do
    result = "/contact 1 visit\n/help_page/1 1 visit\n"
    allow(File).to receive(:readlines).and_return([log_entry_1, log_entry_2])
    expect(parser.most_page_views).to eq result
  end

  it 'returns most page views for multiple log entries' do
    result = "/contact 2 visits\n/help_page/1 1 visit\n"
    log = [log_entry_1, log_entry_2, log_entry_2]
    allow(File).to receive(:readlines).and_return(log)
    expect(parser.most_page_views).to eq result
  end

  it 'returns most unique page views for multiple log entries' do
    result = "/contact 1 visit\n/help_page/1 1 visit\n"
    log = [log_entry_1, log_entry_2, log_entry_2]
    allow(File).to receive(:readlines).and_return(log)
    expect(parser.most_unique_page_views).to eq result
  end
end
