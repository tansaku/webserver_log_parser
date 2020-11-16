# frozen_string_literal: true

describe 'Full System' do
  subject(:parse) { `./parser.rb webserver.log` }
  let(:expected) { File.read('fixtures/expected_output.txt') }

  it 'processes file to produce correct output' do
    expect(parse).to eq expected
  end

  context 'bigger more realistic file' do
    subject(:parse) { `./parser.rb fixtures/kaggle.txt` }
    let(:expected) { File.read('fixtures/expected_kaggle_output.txt') }

    it 'processes file to produce correct output' do
      expect(parse).to eq expected
    end
  end
end
