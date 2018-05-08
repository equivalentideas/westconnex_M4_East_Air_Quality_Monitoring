# frozen_string_literal: true

require 'better_errors' unless %w[production test].include? ENV['RACK_ENV']

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end
