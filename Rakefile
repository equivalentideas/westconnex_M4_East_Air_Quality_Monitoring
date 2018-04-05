# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'

task default: %w[test rubocop]

Rake::TestTask.new do |t|
  t.pattern = 'test/*_test.rb'
  t.libs << 'test'
  t.warning = false
end

RuboCop::RakeTask.new
