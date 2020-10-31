# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names', '-a']
end

RSpec::Core::RakeTask.new(:spec)

desc 'test performance of straight page views vs unique page views'
task :performance do
  require './performance'
end

desc 'test memory performance'
task :performance_memory do
  require './performance_memory'
end

task default: %i[rubocop spec]
