# frozen_string_literal: true

require 'line_parser'

describe LineParser do
  subject(:line_parser) { described_class.run(line, index, logger) }

  let(:index) { {} }
  let(:logger) { double Logger }

  context 'lines with tabs' do
    let(:line) { "/help_page/1\t126.318.035.038" }

    it 'parses successfully' do
      line_parser

      expect(index['/help_page/1']).to match(
        an_object_having_attributes(
          page: '/help_page/1',
          number: 1,
          unique_number: 1
        )
      )
    end
  end

  context 'lines with spaces' do
    let(:line) { '/login/1 126.318.035.038' }

    it 'parses successfully' do
      line_parser
      expect(index['/login/1']).to match(
        an_object_having_attributes(
          page: '/login/1',
          number: 1,
          unique_number: 1
        )
      )
    end
  end

  context 'lines without spaces or tabs' do
    let(:line) { '/login/1126.318.035.038' }

    it 'logs an error and adds nothing to the index' do
      expect(logger).to receive(:warn).twice
      line_parser
      expect(index['/login/1']).to be_nil
    end
  end
end
