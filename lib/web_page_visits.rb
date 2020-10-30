# frozen_string_literal: true

require 'set'

# represents a collection of visits to a page/page
class WebPageVisits
  attr_reader :page

  ERROR = 'unacceptable feature - must be :number or :unique_number'

  def initialize(page, ips)
    @ips = Array(ips)
    @page = page
  end

  def number
    @number ||= @ips.length
  end

  def unique_number
    @unique_number ||= Set.new(@ips).length
  end

  def add(ip)
    @ips << ip
    @number = nil
    @unique_number = nil
  end

  def <=>(other)
    number <=> other.number
  end

  def to_s(feature = :number)
    raise ERROR unless %i[number unique_number].include?(feature)

    "#{page} #{Pluralize.format(send(feature), 'visit')}"
  end
end
