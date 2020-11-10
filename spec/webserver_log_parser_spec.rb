# frozen_string_literal: true

require 'webserver_log_parser'

describe WebserverLogParser do
  let(:log_entry_one) { '/help_page/1 126.318.035.038' }
  let(:log_entry_two) { '/contact 184.123.665.067' }
  let(:bad_log_entry) { '/contact184.123.665.067' }

  subject(:parser) { described_class.parse }

  before do
    LOGGER.level = Logger::ERROR
    allow(File).to receive(:readlines).and_return(log)
  end

  context 'single log entry' do
    let(:log) { [log_entry_one] }
    it_behaves_like 'single entry log parser'
  end

  context 'double log entry' do
    let(:log) { [log_entry_one, log_entry_two] }
    it_behaves_like 'multiple entry log parser'
  end

  context 'triple log entry' do
    let(:log) { [log_entry_one, log_entry_two, log_entry_two] }
    it_behaves_like 'multiple entry log parser' do
      let(:contact_num) { 2 }
    end

    it_behaves_like 'multiple entry log parser' do
      let(:view_method) { :most_unique_page_views }
      let(:num_method) { :unique_number }
    end
  end

  context 'bad log entry' do
    let(:log) { [log_entry_one, log_entry_two, log_entry_two, bad_log_entry] }

    it_behaves_like 'multiple entry log parser' do
      let(:view_method) { :most_unique_page_views }
      let(:num_method) { :unique_number }
    end
  end
end
