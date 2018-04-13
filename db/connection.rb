# frozen_string_literal: true

require 'sequel'

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

Sequel.database_timezone = :utc

DB = Sequel.connect(database_config)
