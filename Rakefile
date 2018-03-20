require 'rake/testtask'
require 'rubocop/rake_task'

task default: %w[test]

Rake::TestTask.new do |t|
  t.pattern = 'test/*_test.rb'
  t.libs << 'test'
end

RuboCop::RakeTask.new
