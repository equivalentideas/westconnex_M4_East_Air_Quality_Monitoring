# frozen_string_literal: true

require 'nokogiri'

# A reading comprising several measurements from an air quality monitoring site
class AqmReading
  attr_reader :raw_data, :location_name, :scraped_at

  # @param raw_data [String] HTML of page containing air quality measurements
  def initialize(raw_data:, location_name:, scraped_at:)
    @raw_data = Nokogiri::HTML(raw_data)
    @location_name = location_name
    @scraped_at = scraped_at
  end

  # Outputs a hash of all the data for this reading, suitable for saving to the database
  def data
    {
      location_name: location_name,
      scraped_at: scraped_at,
      latest_reading_recorded_at: latest_reading_recorded_at,
      pm2_5_concentration_ug_per_m3: measurements['pm2_5_concentration'],
      pm10_concentration_ug_per_m3: measurements['pm10_concentration'],
      co_concentration_ppm: measurements['co_concentration'],
      no2_concentration_ppm: measurements['no2_concentration'],
      differential_temperature_lower_deg_c: measurements['differential_temperature_lower'],
      differential_temperature_upper_deg_c: measurements['differential_temperature_upper'],
      wind_speed_metres_per_second: measurements['wind_speed'],
      wind_direction_deg_true_north: measurements['wind_direction'],
      sigma_deg_true_north: measurements['sigma']
    }
  end

  def latest_reading_recorded_at_raw
    presence(raw_data.at('table thead').text.split('at:').last)
  end

  def latest_reading_recorded_at
    latest_reading_recorded_at_raw
  end

  private

  def measurements
    key_rows = raw_data.search('tbody th').map { |th| tableize(th.text) }
    value_rows = raw_data.search('tbody td').map { |td| extract_value(td.text) }
    measurements = key_rows.zip(value_rows).to_h
  end

  def tableize(string)
    string.downcase.gsub('- ', '').gsub(/(\.| )/, '_')
  end

  def extract_value(string)
    presence(string.split(' ').first)
  end

  # Checks for the presence of a reading, returns nil when there is no reading
  def presence(reading)
    reading == '-' ? nil : reading
  end
end
