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
  namespace :temp do
    # Temporary tasks to help check changes made in https://github.com/equivalentideas/westconnex_M4_East_Air_Quality_Monitoring/pull/40#pullrequestreview-111832606
    namespace :pull_request_40 do
      desc 'Calculate averages for pollution statistics for all sites using Ruby'
      task :ruby do
        require './database'
        measurements = %w[pm2_5_concentration_ug_per_m3 pm10_concentration_ug_per_m3 co_concentration_ppm no2_concentration_ppm]

        measurements.each do |measurement|
          values = AqmRecord.map(measurement.to_sym).compact.map(&:to_f)
          puts "#{measurement}: #{(values.sum(0.0) / values.length).round(10)}"
        end
      end

      desc 'Calculate averages for pollution statistics for all sites using SQL'
      task :sql do
        require './database'
        measurements = %w[pm2_5_concentration_ug_per_m3 pm10_concentration_ug_per_m3 co_concentration_ppm no2_concentration_ppm]

        measurements.each do |measurement|
          puts "#{measurement}: #{AqmRecord.avg(measurement.to_sym).round(10)}"
        end
      end
    end
  end
end
