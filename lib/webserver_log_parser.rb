# frozen_string_literal: true

require 'logger'

LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::WARN

require_relative 'line_parser'
require_relative 'pluralize'
require_relative 'web_page_visits'

# calculates most page views and unique visits for a webserver log
class WebserverLogParser
  def self.parse(filename = 'webserver.log')
    send(:new, filename)
  end

  def most_page_views
    visits.sort.reverse
  end

  def most_unique_page_views
    visits.sort_by(&:unique_number).reverse
  end

  private

  def initialize(filename)
    @index = parse_file(filename)
  end

  def parse_file(filename)
    File.readlines(filename).each_with_object({}) do |line, index|
      LineParser.run(line, index)
    end
  end

  def visits
    @visits ||= @index.values
  end
end
