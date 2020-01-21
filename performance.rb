# frozen_string_literal: true

require 'benchmark'
require './lib/webserver_log_parser'

def page_views
  WebserverLogParser.parse.most_page_views
end

def unique
  WebserverLogParser.parse.most_unique_page_views
end

n = 5000
Benchmark.bm(7) do |x|
  x.report('page views:') { n.times { page_views } }
  x.report('unique:') { n.times { unique } }
end
