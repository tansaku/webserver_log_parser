# frozen_string_literal: true

require 'logger'

LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::WARN

require_relative 'pluralize'
require_relative 'web_page_visits'

SEPARATOR = ' '

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

  attr_reader :visits

  def initialize(filename)
    @index = parse_file(filename)
    @visits = visits_map
  end

  def parse_file(filename)
    File.readlines(filename).each_with_object({}) do |line, index|
      parse_line(line, index)
    end
  end

  def parse_line(line, index)
    raise 'no space character' unless line.include?(SEPARATOR)

    page, ip = line.split(SEPARATOR)
    index[page] ? index[page] << ip : index[page] = [ip]
  rescue StandardError => e
    LOGGER.warn("Unable to parse line: #{line}")
    LOGGER.warn(e)
  end

  def visits_map
    @index.map { |page, ips| WebPageVisits.new(page, ips) }
  end
end
