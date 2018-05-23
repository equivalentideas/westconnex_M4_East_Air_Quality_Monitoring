# frozen_string_literal: true

require_relative '../db/connection'

# Database model for scraped air quality measurement records
class AqmRecord < Sequel::Model; end
