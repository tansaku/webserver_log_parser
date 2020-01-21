# frozen_string_literal: true

require 'set'

# represents a collection of visits to a page/page
class WebPageVisits
  attr_reader :page, :number, :unique_number

  ERROR = 'unacceptable feature - must be :number or :unique_number'

  def initialize(page, ips)
    @ips = ips
    @page = page
    @number = ips.length
    @unique_number = Set.new(ips).length
  end

  def <=>(other)
    @number <=> other.number
  end

  def to_s(feature = :number)
    raise ERROR unless %i[number unique_number].include?(feature)

    "#{page} #{Pluralize.format(send(feature), 'visit')}"
  end
end
