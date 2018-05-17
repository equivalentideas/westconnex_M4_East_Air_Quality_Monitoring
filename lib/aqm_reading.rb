# frozen_string_literal: true

require 'json'
require 'time'

# A reading comprising several measurements from an air quality monitoring site
class AqmReading
  attr_reader :raw_data, :location_name, :scraped_at

  # @param raw_data [String] JSON of page containing air quality measurements
  def initialize(raw_data:, location_name:, scraped_at:)
    @raw_data = JSON.parse(raw_data)
    @location_name = location_name
    @scraped_at = scraped_at
  end

  # Outputs a hash of all the data for this reading, suitable for saving to the database
  def data
    {
      location_name: location_name,
      scraped_at: scraped_at.round,
      latest_reading_recorded_at: latest_reading_recorded_at,
      latest_reading_recorded_at_raw: latest_reading_recorded_at_raw,
      pm2_5_concentration_ug_per_m3: measurements['PM2.5 Concentration'],
      pm10_concentration_ug_per_m3: measurements['PM10 Concentration'],
      co_concentration_ppm: measurements['CO Concentration'],
      no2_concentration_ppm: measurements['NO2 Concentration'],
      differential_temperature_lower_deg_c: measurements['Differential Temperature - Lower'],
      differential_temperature_upper_deg_c: measurements['Differential Temperature - Upper'],
      wind_speed_metres_per_second: measurements['Wind Speed'],
      wind_direction_deg_true_north: measurements['Wind Direction'],
      sigma_deg_true_north: measurements['Sigma']
    }
  end

  def latest_reading_recorded_at_raw
    raw_data['Footer'][0][1]
  end

  def latest_reading_recorded_at
    return if latest_reading_recorded_at_raw.nil? || latest_reading_recorded_at_raw.strip.empty?
    Time.parse(latest_reading_recorded_at_raw)
  end

  private

  def measurements
    key_rows = raw_data['Header'][1..-1]
    value_rows = raw_data['Footer'][1][1..-1].map { |measurement| extract_value(measurement).to_f }

    key_rows.zip(value_rows).to_h
  end

  def extract_value(string)
    presence(string.split(' ').first)
  end

  # Checks for the presence of a reading, returns nil when there is no reading
  def presence(reading)
    reading == '-' ? nil : reading
  end
end
