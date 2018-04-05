# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require_relative '../app'

module Minitest
  class Spec
    include Rack::Test::Methods

    def app
      Sinatra::Application
    end
  end
end
