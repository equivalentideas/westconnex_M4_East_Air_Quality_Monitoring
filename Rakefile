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

namespace :statistics do
  desc 'Powells Creek PM10 averages with and without negative values'
  task :powells_creek_pm10_negatives do
    require 'date'
    require './database'

    powells_creek = AqmRecord.where(location_name: 'Powells Creek AQM')

    puts 'date, records, average, average_without_negatives'

    (Date.new(2018, 3, 16)...Date.today).each do |date|
      date_filter = Sequel.like(:latest_reading_recorded_at, date.strftime('%B %-d, %Y%'))
      records = powells_creek.where(date_filter)
      average = records.avg(:pm10_concentration_ug_per_m3)&.round(2)
      average_without_negatives = records.where { pm10_concentration_ug_per_m3 > 0 }.avg(:pm10_concentration_ug_per_m3)&.round(2)
      count = records.count

      puts "#{date}, #{count}, #{average}, #{average_without_negatives}"
    end
  end
end
