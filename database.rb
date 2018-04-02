# frozen_string_literal: true

require 'active_record'

def database_config
  if ENV['RACK_ENV'] == 'production'
    ENV['DATABASE_URL']
  elsif ENV['RACK_ENV'] == 'test' && ENV['TRAVIS'] == 'true'
    { adapter: 'postgresql', database: 'travis_ci_test' }
  elsif ENV['RACK_ENV'] == 'test'
    {
      adapter: 'postgresql',
      host: 'localhost',
      username: 'westconnex_m4east_aqm',
      password: ENV['DEVELOPMENT_DATABASE_PASSWORD'],
      database: 'westconnex_m4east_aqm_test'
    }
  else # development
    {
      adapter: 'postgresql',
      host: 'localhost',
      username: 'westconnex_m4east_aqm',
      password: ENV['DEVELOPMENT_DATABASE_PASSWORD'],
      database: 'westconnex_m4east_aqm_development'
    }
  end
end

ActiveRecord::Base.establish_connection(database_config)

class AqmRecord < ActiveRecord::Base; end

unless AqmRecord.table_exists?
  ActiveRecord::Schema.define do
    create_table :aqm_records do |t|
      t.string :location_name
      t.string :scraped_at
      t.string :latest_reading_recorded_at
      t.string :pm2_5_concentration
      t.string :pm10_concentration
      t.string :co_concentration
      t.string :no2_concentration
      t.string :differential_temperature_lower
      t.string :differential_temperature_upper
      t.string :wind_speed
      t.string :wind_direction
      t.string :sigma
    end
  end
  AqmRecord.reset_column_information
end
