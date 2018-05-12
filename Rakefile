# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'

task default: %w[test rubocop]

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
  t.libs << 'test'
  t.warning = false
end

RuboCop::RakeTask.new

namespace :db do
  desc 'Run database migrations'
  task :migrate, [:version] do |_t, args|
    require './db/connection'
    Sequel.extension :migration
    if args[:version]
      puts "Migrating database to version #{args[:version]}"
      Sequel::Migrator.run(DB, 'db/migrations', target: args[:version].to_i)
    else
      puts 'Migrating database to latest version'
      Sequel::Migrator.run(DB, 'db/migrations')
    end
  end
end
