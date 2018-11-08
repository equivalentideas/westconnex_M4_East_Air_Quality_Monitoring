# frozen_string_literal: true

require 'sequel'
require 'yaml'

def environment
  if ENV['RACK_ENV'] == 'production'
    'production'
  elsif ENV['RACK_ENV'] == 'test'
    'test'
  else
    'development'
  end
end

def config_yml
  YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml'))
end

def config_docker
  common_config = { adapter: 'postgres', host: 'db', username: 'postgres' }
  {
    'test' => common_config.merge(database: 'westconnex_m4east_aqm_test'),
    'development' => common_config.merge(database: 'westconnex_m4east_aqm_development')
  }
end

def config
  ENV['DOCKER'] == 'true' ? config_docker : config_yml
end

def database_config
  ENV['DATABASE_URL'] ? ENV['DATABASE_URL'] : config[environment]
end

Sequel.database_timezone = :utc
Sequel.application_timezone = :local

DB = Sequel.connect(database_config)
