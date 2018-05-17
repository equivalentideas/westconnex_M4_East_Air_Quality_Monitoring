# frozen_string_literal: true

require 'test_helper'
require_relative '../lib/aqm_reading'

describe AqmReading do
  describe 'with complete and valid raw data' do
    let(:scraped_at) { Time.now }
    subject do
      haberfield_json = File.read(File.join(File.dirname(__FILE__), 'fixtures/haberfield.json'))
      AqmReading.new(raw_data: haberfield_json, location_name: 'Haberfield Public School AQM', scraped_at: scraped_at)
    end

    describe '#data' do
      it 'should provide a hash of all the data' do
        subject.data.must_equal(
          location_name: 'Haberfield Public School AQM',
          scraped_at: scraped_at,
          latest_reading_recorded_at: Time.new(2018, 5, 11, 5, 30, 0, '+00:00'),
          latest_reading_recorded_at_raw: '2018-05-11T05:30:00Z',
          pm2_5_concentration_ug_per_m3: 14,
          pm10_concentration_ug_per_m3: 16,
          co_concentration_ppm: 0,
          no2_concentration_ppm: 0.007,
          differential_temperature_lower_deg_c: 15.8,
          differential_temperature_upper_deg_c: 15.7,
          wind_speed_metres_per_second: 4.6,
          wind_direction_deg_true_north: 266,
          sigma_deg_true_north: 23.3
        )
      end
    end

    describe '#latest_reading_recorded_at' do
      it 'should parse to a Time object' do
        subject.latest_reading_recorded_at.must_be_kind_of Time
      end

      it 'should have the correct UTC time' do
        subject.latest_reading_recorded_at.must_equal Time.new(2018, 5, 11, 5, 30, 0, '+00:00')
      end
    end

    describe '#latest_reading_recorded_at_raw' do
      it 'should have the raw string value' do
        subject.latest_reading_recorded_at_raw.must_equal '2018-05-11T05:30:00Z'
      end
    end
  end

  describe '#latest_reading_recorded_at' do
    subject { AqmReading.new(raw_data: '[]', location_name: nil, scraped_at: nil) }

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
  end
end
