# frozen_string_literal: true

require 'test_helper'
require_relative '../aqm_reading'

describe AqmReading do
  subject do
    haberfield_html = File.read(File.join(File.dirname(__FILE__), 'fixtures/haberfield.html'))
    AqmReading.new(raw_data: haberfield_html)
  end

  it 'should provide a hash of all the data' do
    subject.data.must_equal({
      location_name: 'Haberfield Public School AQM',
      scraped_at: Time.now,
      latest_reading_recorded_at: Time.new(2018, 5, 11, 15, 30, 0, 10),
      pm2_5_concentration_ug_per_m3: 14,
      pm10_concentration_ug_per_m3: 16,
      co_concentration_ppm: 0,
      no2_concentration_ppm: 0.007,
      differential_temperature_lower_deg_c: 15.8,
      differential_temperature_upper_deg_c: 15.7,
      wind_speed_metres_per_second: 4.6,
      wind_direction_deg_true_north: 266,
      sigma_deg_true_north: 23.3
    })
  end
end
