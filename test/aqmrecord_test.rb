# frozen_string_literal: true

require 'test_helper'
require_relative '../database'

describe AqmRecord do
  it 'can be initialized with location_name' do
    record = AqmRecord.new(location_name: 'foo')

    record.location_name.must_equal 'foo'
  end

  it 'gets and sets attributes' do
    record = AqmRecord.new

    record.scraped_at = Time.utc(2018, 4, 25, 17, 35)
    record.pm2_5_concentration_ug_per_m3 = 1
    record.pm10_concentration_ug_per_m3 = 2
    record.co_concentration_ppm = 3
    record.no2_concentration_ppm = 4
    record.differential_temperature_lower_deg_c = 5
    record.differential_temperature_upper_deg_c = 6
    record.wind_speed_metres_per_second = 8
    record.wind_direction_deg_true_north = 9
    record.sigma_deg_true_north = 10
    record.latest_reading_recorded_at_raw = 'April 25, 2018 14:00:00 AEST'

    record.scraped_at.must_equal Time.utc(2018, 4, 25, 17, 35)
    record.pm2_5_concentration_ug_per_m3.must_equal 1
    record.pm10_concentration_ug_per_m3.must_equal 2
    record.co_concentration_ppm.must_equal 3
    record.no2_concentration_ppm.must_equal 4
    record.differential_temperature_lower_deg_c.must_equal 5
    record.differential_temperature_upper_deg_c.must_equal 6
    record.wind_speed_metres_per_second.must_equal 8
    record.wind_direction_deg_true_north.must_equal 9
    record.sigma_deg_true_north.must_equal 10
    record.latest_reading_recorded_at_raw.must_equal 'April 25, 2018 14:00:00 AEST'
  end
end
