#!/usr/bin/env ruby
# frozen_string_literal: true

require './lib/webserver_log_parser'

puts "processing '#{ARGV[0]}' ..."
puts

puts 'MOST PAGE VIEWS'
puts '---------------'
puts WebserverLogParser.parse(ARGV[0]).most_page_views
puts
puts 'MOST UNIQUE PAGE VIEWS'
puts '----------------------'
puts WebserverLogParser.parse(ARGV[0]).most_unique_page_views
