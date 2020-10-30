# frozen_string_literal: true

require 'logger'

LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::WARN

require_relative 'pluralize'
require_relative 'web_page_visits'

SPACE_SEPARATOR = ' '
TAB_SEPARATOR = "\t"

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
      parse_line(line, index)
    end
  end

  def parse_line(line, index)
    raise 'no space characters or tabs' unless separator_type(line)

    page, ip = line.split(separator_type(line))

    if index[page]
      index[page].add(ip)
    else
      index[page] = WebPageVisits.new(page, [ip])
    end
  rescue StandardError => e
    LOGGER.warn("Unable to parse line: #{line}")
    LOGGER.warn(e)
  end

  def visits
    @visits ||= @index.values
  end

  def separator_type(line)
    return TAB_SEPARATOR if line.include?(TAB_SEPARATOR)
    return SPACE_SEPARATOR if line.include?(SPACE_SEPARATOR)

    nil
  end
end
