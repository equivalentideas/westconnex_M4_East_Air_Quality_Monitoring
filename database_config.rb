def environment
  ENV['SCRIPT_ENV'] == 'production' ?  :production : :development
end

DATABASE_SETTINGS = {
  development: {
    host: 'localhost',
    username: 'westconnex_m4east_aqm',
    password: ENV['DEVELOPMENT_DATABASE_PASSWORD'],
    database: 'westconnex_m4east_aqm_development'
  },
  production: {
    url: ENV['DATABASE_URL']
  }
}.freeze

ActiveRecord::Base.establish_connection(
  { adapter: 'postgresql' }.merge(DATABASE_SETTINGS[environment])
)
