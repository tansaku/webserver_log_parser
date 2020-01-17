# frozen_string_literal: true

# require 'byebug'
# returns most page views
class MostViewedPages
  def self.list
    index = {}
    File.readlines('webserver.log').each do |line|
      page, ip = line.split(' ')
      index[page] ? index[page] << ip : index[page] = [ip]
    end
    index.reduce('') do |string, (page, ips)|
      string + "#{page} #{Pluralize.format(ips.length, 'visit')}\n"
    end
  end
end
