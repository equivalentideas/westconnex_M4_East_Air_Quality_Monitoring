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

  describe '#latest_reading_recorded_at' do
    subject { AqmReading.new(raw_data: nil, location_name: nil, scraped_at: nil) }

    [nil, '', ' '].each do |value|
      value_as_string = value.nil? ? 'nil' : %("#{value}")

      describe "blank value #{value_as_string}" do
        it 'should be recorded as nil' do
          subject.stub :latest_reading_recorded_at_raw, value do
            subject.latest_reading_recorded_at.must_be_nil
          end
        end
      end
    end

    describe 'when date and time is +10 time' do
      it 'converts it to UTC' do
        subject.stub :latest_reading_recorded_at_raw, '24 April 2018 at 3:30:00 pm AEST' do
          subject.latest_reading_recorded_at.must_equal Time.new(2018, 4, 24, 5, 30, 0, '+00:00')
        end
      end
    end

    describe 'when date and time is +10 time and incorrectly marked GMT' do
      it 'reads it as +10 time and converts it to UTC' do
        subject.stub :latest_reading_recorded_at_raw, 'April 24, 2018 3:30:00 PM GMT' do
          subject.latest_reading_recorded_at.must_equal Time.new(2018, 4, 24, 5, 30, 0, '+00:00')
        end
      end
    end

    describe 'when date and time is +10 time and incorrectly marked AEDT' do
      it 'reads it as +10 time and converts it to UTC' do
        subject.stub :latest_reading_recorded_at_raw, '24 April 2018 3:30:00 pm AEDT' do
          subject.latest_reading_recorded_at.must_equal Time.new(2018, 4, 24, 5, 30, 0, '+00:00')
        end
      end

      describe 'without a padded day number' do
        it 'converts it successfully' do
          subject.stub :latest_reading_recorded_at_raw, 'April 7, 2018 1:00:00 AM GMT' do
            subject.latest_reading_recorded_at.must_equal Time.new(2018, 4, 6, 15, 0, 0, '+00:00')
          end
        end
      end
    end
  end
end
