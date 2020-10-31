require 'memory_profiler'
require './lib/webserver_log_parser'

def page_views
  WebserverLogParser.parse.most_page_views
end

report = MemoryProfiler.report do
  page_views
end

report.pretty_print
