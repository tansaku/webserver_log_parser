# frozen_string_literal: true

require 'terminal-table'

# formats visit information into text tables
class WebPageVisitsPresenter
  def initialize(webserver_log_parser)
    @filename = webserver_log_parser.filename
    @visits = webserver_log_parser.visits
  end

  def to_s
    str = "processing '#{filename}' ...\n"
    str += "\n"
    str += "displaying up to top 10 in each category\n"
    str += "\n"
    str += output_table(:most_page_views, :number).to_s
    str += "\n"
    str += "\n"
    str += output_table(:most_unique_page_views, :unique_number).to_s
    str
  end

  private

  attr_reader :filename, :visits

  def output_table(view_method, number_method)
    rows = send(view_method).map do |visit|
      [visit.page, Pluralize.format(visit.send(number_method), 'visit')]
    end
    Terminal::Table.new(
      title: view_method.to_s.capitalize.gsub(/_/, ' '),
      headings: %w[Page Visits],
      rows: rows[0..10]
    )
  end

  def most_page_views
    visits.sort.reverse
  end

  def most_unique_page_views
    visits.sort_by(&:unique_number).reverse
  end
end
