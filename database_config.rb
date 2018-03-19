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
