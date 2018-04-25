# frozen_string_literal: true

module Aqm
  # Receives data and serializes it for AqmRecord
  class Reading
    attr_accessor :location_name
    attr_accessor :scraped_at
    attr_accessor :latest_reading_recorded_at_raw
    attr_accessor :pm2_5_concentration
    attr_accessor :pm10_concentration
    attr_accessor :co_concentration
    attr_accessor :no2_concentration
    attr_accessor :differential_temperature_lower
    attr_accessor :differential_temperature_upper
    attr_accessor :wind_speed
    attr_accessor :wind_direction
    attr_accessor :sigma

    def initialize(location_name: nil)
      @location_name = location_name
    end

    def extract_attributes_from_hash(hash)
      self.pm2_5_concentration = hash['pm2_5_concentration']
      self.pm10_concentration = hash['pm10_concentration']
      self.co_concentration = hash['co_concentration']
      self.no2_concentration = hash['no2_concentration']
      self.differential_temperature_lower = hash['differential_temperature_lower']
      self.differential_temperature_upper = hash['differential_temperature_upper']
      self.wind_speed = hash['wind_speed']
      self.wind_direction = hash['wind_direction']
      self.sigma = hash['sigma']
    end

    def latest_reading_recorded_at_converted
      return unless latest_reading_recorded_at_raw && !latest_reading_recorded_at_raw.empty?

      time = Time.parse(latest_reading_recorded_at_raw_relabled_utc) - (60 * 60 * 10)
      time.to_s
    end

    def serialize
      {
        location_name: location_name,
        scraped_at: scraped_at,
        latest_reading_recorded_at: latest_reading_recorded_at_converted,
        latest_reading_recorded_at_raw: latest_reading_recorded_at_raw,
        pm2_5_concentration_ug_per_m3: pm2_5_concentration,
        pm10_concentration_ug_per_m3: pm10_concentration,
        co_concentration_ppm: co_concentration,
        no2_concentration_ppm: no2_concentration,
        differential_temperature_lower_deg_c: differential_temperature_lower,
        differential_temperature_upper_deg_c: differential_temperature_upper,
        wind_speed_metres_per_second: wind_speed,
        wind_direction_deg_true_north: wind_direction,
        sigma_deg_true_north: sigma
      }
    end

    private

    def latest_reading_recorded_at_raw_relabled_utc
      latest_reading_recorded_at_raw.gsub(/\b\S*$/, '+0000')
    end
  end
end
