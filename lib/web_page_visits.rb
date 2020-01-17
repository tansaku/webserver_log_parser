# frozen_string_literal: true

require 'set'
# represents a collection of visits to a page/path
class WebPageVisits
  attr_reader :path, :number, :unique_number

  def initialize(path, ips)
    @ips = ips
    @path = path
    @number = ips.length
    @unique_number = Set.new(ips).length
  end

  def <=>(other)
    @number <=> other.number
  end
end
