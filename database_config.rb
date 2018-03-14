@database_connection = ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  username: 'westconnex_m4east_aqm',
  password: ENV['DEVELOPMENT_DATABASE_PASSWORD'],
  database: 'westconnex_m4east_aqm'
)
