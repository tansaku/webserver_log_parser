# frozen_string_literal: true

require 'webserver_log_parser'

describe WebserverLogParser do
  let(:log_entry_one) { '/help_page/1 126.318.035.038' }
  let(:log_entry_two) { '/contact 184.123.665.067' }
  let(:bad_log_entry) { '/contact184.123.665.067' }

  subject(:parser) { described_class.new }

  before do
    LOGGER.level = Logger::ERROR
    allow(File).to receive_message_chain(:read, :split).and_return(log)
  end

  context 'single log entry' do
    let(:log) { [log_entry_one] }

    it 'has one visit' do
      expect(parser.visits.count).to eq 1
    end
  end

  context 'double log entry' do
    let(:log) { [log_entry_one, log_entry_two] }

    it 'has two visits' do
      expect(parser.visits.count).to eq 2
    end
  end

  context 'triple log entry with duplication' do
    let(:log) { [log_entry_one, log_entry_two, log_entry_two] }

    it 'has two visits' do
      expect(parser.visits.count).to eq 2
    end
  end

  context 'bad log entry' do
    let(:log) { [log_entry_one, log_entry_two, log_entry_two, bad_log_entry] }

    it 'is ignored' do
      expect(parser.visits.count).to eq 2
    end
  end
end
