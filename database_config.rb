DEV_DATABASE_CONFIG = {adapter: 'sqlite3', database: 'data.sqlite'}.freeze

def environment
  ENV['SCRIPT_ENV'] == 'production' ?  :production : :development
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
