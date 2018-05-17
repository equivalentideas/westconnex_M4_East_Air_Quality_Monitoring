# frozen_string_literal: true

require 'test_helper'
require_relative '../lib/aqm_reading'

describe AqmReading do
  # All tests are wrapped in this Timecop block to make testing scraped_at easier
  Timecop.freeze do
    subject do
      haberfield_html = File.read(File.join(File.dirname(__FILE__), 'fixtures/haberfield.html'))
      AqmReading.new(raw_data: haberfield_html, location_name: 'Haberfield Public School AQM', scraped_at: Time.now)
    end

    describe '#data' do
      it 'should provide a hash of all the data' do
        subject.data.must_equal({
          location_name: 'Haberfield Public School AQM',
          scraped_at: Time.now,
          latest_reading_recorded_at: Time.new(2018, 5, 11, 15, 30, 0, '+10:00'),
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

    describe '#latest_reading_recorded_at' do
      it 'should extract the correct value' do
        subject.latest_reading_recorded_at.must_equal Time.new(2018, 5, 11, 15, 30, 0, '+10:00')
      end
    end

    describe '#latest_reading_recorded_at_raw' do
      it 'should have the raw string value' do
        subject.latest_reading_recorded_at_raw.must_equal '11 May 2018 3:30:00 PM AEST'
      end
    end
  end
end
