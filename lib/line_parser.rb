# frozen_string_literal: true

SPACE_SEPARATOR = ' '
TAB_SEPARATOR = "\t"

# parsers an individual weblog line
class LineParser
  def self.run(line, index, logger = LOGGER)
    new(line, index, logger)
  end

  private

  attr_reader :index, :page, :ip, :line

  def initialize(line, index, logger)
    @line = line
    raise 'no space characters or tabs' unless separator_type

    @page, @ip = line.split(separator_type)
    @index = index
    parse_line
  rescue StandardError => e
    logger.warn("Unable to parse line: #{line}")
    logger.warn(e)
  end

  def parse_line
    if index[page]
      index[page].add(ip)
    else
      index[page] = WebPageVisits.new(page, [ip])
    end
  end

  def separator_type
    return TAB_SEPARATOR if line.include?(TAB_SEPARATOR)
    return SPACE_SEPARATOR if line.include?(SPACE_SEPARATOR)

    nil
  end
end
