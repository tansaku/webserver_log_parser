# frozen_string_literal: true

shared_examples 'multiple entry log parser' do
  let(:contact_num) { 1 }
  let(:view_method) { :most_page_views }
  let(:num_method) { :number }

  it 'returns correct results for multiple log entries' do
    expect(parser.send(view_method)).to contain_exactly(
      an_object_having_attributes(page: '/contact', num_method => contact_num),
      an_object_having_attributes(page: '/help_page/1', num_method => 1)
    )
  end
end

shared_examples 'single entry log parser' do
  let(:contact_num) { 1 }
  let(:view_method) { :most_page_views }
  let(:num_method) { :number }
  let(:page) { '/help_page/1' }

  it 'returns correct results for multiple log entries' do
    expect(parser.send(view_method)).to contain_exactly(
      an_object_having_attributes(page: page, num_method => contact_num)
    )
  end
end
