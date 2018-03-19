require 'active_record'

DEV_DATABASE_CONFIG = {
  adapter: 'postgresql',
  host: 'localhost',
  username: 'westconnex_m4east_aqm',
  password: ENV['DEVELOPMENT_DATABASE_PASSWORD'],
  database: 'westconnex_m4east_aqm_development'
}.freeze

def environment
  ENV['RACK_ENV'] == 'production' ?  :production : :development
end

def production_db_config
  ActiveRecord::ConnectionAdapters::ConnectionSpecification::ConnectionUrlResolver.new(
    ENV['DATABASE_URL']
  ).to_hash
end

def database_config
  environment == :production ? production_db_config : DEV_DATABASE_CONFIG
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
end
