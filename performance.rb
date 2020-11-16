# frozen_string_literal: true

require 'benchmark'
require './lib/webserver_log_parser'

def page_views
  WebserverLogParser.new.visits.sort.reverse
end

def unique
  WebserverLogParser.new.visits.sort_by(&:unique_number).reverse
end

n = 5000
Benchmark.bm(7) do |x|
  x.report('page views:') { n.times { page_views } }
  x.report('unique:') { n.times { unique } }
end
