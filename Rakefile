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
  desc 'PM2.5 and PM10 daily averages with and without negative values'
  task :pm2_5_pm10_with_without_negatives do
    require 'date'
    require './database'

    first_record_date = AqmRecord.order(:scraped_at).first.scraped_at.to_date
    location_names = AqmRecord.distinct(:location_name).select_map(:location_name)

    location_names.each do |location_name|
      puts location_name
      puts 'date, records, pm2.5_average, pm2.5_average_with_negatives, pm10_average, pm10_average_with_negatives'
      location_records = AqmRecord.where(location_name: location_name)

      (first_record_date..Date.today).each do |date|
        # Casting to Time and using > and < is necessary here for the filter to take into account timezone conversion
        records = location_records.where{ (latest_reading_recorded_at >= date.to_time) & (latest_reading_recorded_at < date.next_day.to_time) }

        pm2_5_average = records.where { pm2_5_concentration_ug_per_m3 >= 0 }.avg(:pm2_5_concentration_ug_per_m3)&.round(2)
        pm2_5_average_with_negatives = records.avg(:pm2_5_concentration_ug_per_m3)&.round(2)
        pm10_average = records.where { pm10_concentration_ug_per_m3 >= 0 }.avg(:pm10_concentration_ug_per_m3)&.round(2)
        pm10_average_with_negatives = records.avg(:pm10_concentration_ug_per_m3)&.round(2)
        count = records.count

        puts "#{date}, #{count}, #{pm2_5_average}, #{pm2_5_average_with_negatives}, #{pm10_average}, #{pm10_average_with_negatives}"
      end
    end
  end
end
