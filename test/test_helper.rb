# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'timecop'
require 'database_cleaner'
require_relative '../app'

DatabaseCleaner.strategy = :transaction

module Minitest
  class Spec
    include Rack::Test::Methods

    def app
      Sinatra::Application
    end

    before :each do
      # Set timezone to UTC+10 as this is what we use on the server
      ENV['TZ'] = 'Etc/GMT-10'

      DatabaseCleaner.start
    end

    after :each do
      DatabaseCleaner.clean
    end
  end
end
