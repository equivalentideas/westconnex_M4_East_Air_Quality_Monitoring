# frozen_string_literal: true

require 'sequel'

def environment
  if ENV['RACK_ENV'] == 'production'
    :production
  elsif ENV['RACK_ENV'] == 'test' && ENV['TRAVIS'] == 'true'
    :travis
  elsif ENV['RACK_ENV'] == 'test'
    :test
  else
    :development
  end
end

def database_config
  {
    production: ENV['DATABASE_URL'],
    travis: { adapter: 'postgresql', database: 'travis_ci_test' },
    test: {
      adapter: 'postgresql',
      host: 'localhost',
      username: 'westconnex_m4east_aqm',
      password: ENV['DEVELOPMENT_DATABASE_PASSWORD'],
      database: 'westconnex_m4east_aqm_test'
    },
    development: {
      adapter: 'postgresql',
      host: 'localhost',
      username: 'westconnex_m4east_aqm',
      password: ENV['DEVELOPMENT_DATABASE_PASSWORD'],
      database: 'westconnex_m4east_aqm_development'
    }
  }
end

Sequel.database_timezone = :utc
Sequel.application_timezone = :local

DB = Sequel.connect(database_config[environment])
