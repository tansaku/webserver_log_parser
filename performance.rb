# frozen_string_literal: true

require 'benchmark'
require './lib/most_viewed_pages'
n = 5000
Benchmark.bm(7) do |x|
  x.report('naive:') { n.times { MostViewedPages.list } }
end
