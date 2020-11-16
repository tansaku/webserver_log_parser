# frozen_string_literal: true

require 'logger'

LOGGER = Logger.new($stdout)
LOGGER.level = Logger::WARN

require_relative 'line_parser'
require_relative 'pluralize'
require_relative 'web_page_visits'

# calculates most page views and unique visits for a webserver log
class WebserverLogParser
  attr_reader :filename

  def initialize(filename = 'webserver.log')
    @filename = filename
    @index = parse_file(filename)
  end

  def visits
    @visits ||= @index.values
  end

  private

  def parse_file(filename)
    File.read(filename).split("\n").each_with_object({}) do |line, index|
      LineParser.run(line, index)
    end
  end
end
