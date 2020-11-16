# frozen_string_literal: true

require 'memory_profiler'
require './lib/webserver_log_parser'

def page_views
  WebserverLogParser.new.visits.sort.reverse
end

report = MemoryProfiler.report do
  page_views
end

report.pretty_print
