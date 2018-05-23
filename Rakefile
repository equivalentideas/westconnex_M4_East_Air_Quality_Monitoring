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

namespace :fix do
  # TODO: Should be removed once deployed and successfully run
  desc 'Fix incorrect latest_reading_recorded_at - see #54'
  task :incorrect_latest_reading_recorded_at do
    require './lib/aqm_record'
    # This was the last scraped record before the problematic deploy
    last_correct_reading_scraped_at = Time.new(2018, 5, 1, 21, 51, 44, '+10:00')

    AqmRecord.where { scraped_at > last_correct_reading_scraped_at }.exclude(latest_reading_recorded_at: nil).each do |record|
      # The actual problem is that latest_reading_recorded_at_raw is now in GMT instead of AEST so a straight `#parse` is all we need
      record.update(latest_reading_recorded_at: Time.parse(record.latest_reading_recorded_at_raw))
    end
  end
end
