#!/usr/bin/env ruby
# frozen_string_literal: true

require 'commander/import'

require './lib/webserver_log_parser'
require './lib/web_page_visits_presenter'

program :name, 'Webserver Log Parser'
program :version, '0.0.1'
program :description, 'Display Most Visited Pages and Most Unique Page Visits.'

default_command :parser

command :parser do |c|
  c.syntax = 'parser <filename>'
  c.description = 'parses weblog'
  c.action do |args, _options|
    raise ArgumentError, "filename is required, '#{c.syntax}'" if args.empty?

    puts WebPageVisitsPresenter.new(WebserverLogParser.new(args[0])).to_s
  end
end
