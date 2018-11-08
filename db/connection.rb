# frozen_string_literal: true

require 'sequel'
require 'yaml'

def environment
  if ENV['RACK_ENV'] == 'production'
    :production
  elsif ENV['RACK_ENV'] == 'test'
    :test
  else
    :development
  end
end

def config_yml
  YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml'))
end

def database_config
  {
    production: ENV['DATABASE_URL'],
    test: config_yml['test'],
    development: config_yml['development']
  }
end

Sequel.database_timezone = :utc
Sequel.application_timezone = :local

DB = Sequel.connect(database_config[environment])
