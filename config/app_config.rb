# frozen_string_literal: true

require 'better_errors' unless %w[production test].include? ENV['RACK_ENV']

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
  BetterErrors::Middleware.allow_ip! '172.16.0.0/12'
end

require './db/connection'
require './lib/aqm_record'
require './lib/models/monitor'
require './lib/helpers'
