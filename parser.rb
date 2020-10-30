#!/usr/bin/env ruby
# frozen_string_literal: true

require 'commander/import'
require 'terminal-table'
require './lib/webserver_log_parser'

program :name, 'Webserver Log Parser'
program :version, '0.0.1'
program :description, 'Display Most Visited Pages and Most Unique Page Visits.'

default_command :parser

command :parser do |c|
  c.syntax = 'parser <filename>'
  c.description = 'parses weblog'
  c.action do |args, _options|
    raise ArgumentError, "filename is required, '#{c.syntax}'" if args.empty?

    output(args[0])
  end
end

def output(filename)
  puts "processing '#{filename}' ..."
  puts
  puts 'displaying up to top 10 in each category'
  puts
  puts output_table(filename, :most_page_views, :number)
  puts
  puts output_table(filename, :most_unique_page_views, :unique_number)
end

def output_table(filename, view_method, number_method)
  rows = parsed_data(filename).send(view_method).map do |visit|
    [visit.page, Pluralize.format(visit.send(number_method), 'visit')]
  end
  Terminal::Table.new(
    title: view_method.to_s.capitalize.gsub(/_/, ' '),
    headings: %w[Page Visits],
    rows: rows[0..10]
  )
end

def parsed_data(filename)
  @parsed_data ||= WebserverLogParser.parse(filename)
end
