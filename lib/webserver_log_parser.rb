# frozen_string_literal: true

require_relative 'pluralize'
require_relative 'web_page_visits'

# calculates most page views and unique visits for a webserver log
class WebserverLogParser
  def self.parse(filename = 'webserver.log')
    send(:new, filename)
  end

  def most_page_views
    @visits.sort.reverse.map do |visits|
      "#{visits.path} #{Pluralize.format(visits.number, 'visit')}\n"
    end.join
  end

  def most_unique_page_views
    @visits.sort_by(&:unique_number).reverse.map do |visits|
      "#{visits.path} #{Pluralize.format(visits.unique_number, 'visit')}\n"
    end.join
  end

  private

  def initialize(filename)
    @index = {}
    File.readlines(filename).each do |line|
      page, ip = line.split(' ')
      @index[page] ? @index[page] << ip : @index[page] = [ip]
    end
    @visits = @index.map do |path, ips|
      WebPageVisits.new(path, ips)
    end
  end
end
