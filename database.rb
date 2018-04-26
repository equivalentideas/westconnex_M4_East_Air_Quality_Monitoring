# frozen_string_literal: true

require './db/connection'

# Database model for scraped air quality measurement records
class AqmRecord < Sequel::Model
  # Store raw value as a backup and convert value to UTC for storage in the database
  def latest_reading_recorded_at=(date_and_time)
    return if date_and_time.strip.empty?

    @values[:latest_reading_recorded_at_raw] = date_and_time
    @values[:latest_reading_recorded_at] = (Time.parse(date_and_time.gsub(/\b\S*$/, '+0000')) - (60 * 60 * 10)).to_s
  end
end
