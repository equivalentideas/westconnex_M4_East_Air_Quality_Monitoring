# frozen_string_literal: true

require 'test_helper'
require_relative '../lib/reading'

describe Aqm::Reading do
  it 'can be initialized with location_name' do
    reading = Aqm::Reading.new(location_name: 'foo')

    reading.location_name.must_equal 'foo'
  end

  it 'gets and sets attributes' do
    reading = Aqm::Reading.new

    reading.scraped_at = Time.utc(2018, 4, 25, 17, 35)
    reading.pm2_5_concentration = 1
    reading.pm10_concentration = 2
    reading.co_concentration = 3
    reading.no2_concentration = 4
    reading.differential_temperature_lower = 5
    reading.differential_temperature_upper = 6
    reading.wind_speed = 8
    reading.wind_direction = 9
    reading.sigma = 10
    reading.latest_reading_recorded_at_raw = 'April 25, 2018 14:00:00 AEST'

    reading.scraped_at.must_equal Time.utc(2018, 4, 25, 17, 35)
    reading.pm2_5_concentration.must_equal 1
    reading.pm10_concentration.must_equal 2
    reading.co_concentration.must_equal 3
    reading.no2_concentration.must_equal 4
    reading.differential_temperature_lower.must_equal 5
    reading.differential_temperature_upper.must_equal 6
    reading.wind_speed.must_equal 8
    reading.wind_direction.must_equal 9
    reading.sigma.must_equal 10
    reading.latest_reading_recorded_at_raw.must_equal 'April 25, 2018 14:00:00 AEST'
  end

  describe '#extract_attributes_from_hash' do
    it 'assigns attributes and ignores unknown keys' do
      reading = Aqm::Reading.new
      hash = {
        'foo' => 'bar',
        '-' => nil,
        'pm2_5_concentration' => 1,
        'pm10_concentration' => 2,
        'co_concentration' => 3,
        'no2_concentration' => 4,
        'differential_temperature_lower' => 5,
        'differential_temperature_upper' => 6,
        'wind_speed' => 7,
        'wind_direction' => 8,
        'sigma' => 9
      }

      reading.extract_attributes_from_hash(hash)

      reading.pm2_5_concentration.must_equal 1
      reading.pm10_concentration.must_equal 2
      reading.co_concentration.must_equal 3
      reading.no2_concentration.must_equal 4
      reading.differential_temperature_lower.must_equal 5
      reading.differential_temperature_upper.must_equal 6
      reading.wind_speed.must_equal 7
      reading.wind_direction.must_equal 8
      reading.sigma.must_equal 9
    end
  end

  describe '#latest_reading_recorded_at_converted' do
    before do
      @reading = Aqm::Reading.new
    end

    describe 'when latest_reading_recorded_at_raw is nil' do
      it 'should be nil' do
        @reading.latest_reading_recorded_at_converted.must_be :nil?
      end
    end

    describe 'when latest_reading_recorded_at_raw is a date string' do
      before do
        @reading.latest_reading_recorded_at_raw = '24 April 2018 at 3:30:00 pm AEST'
      end

      it 'should be a String' do
        @reading.latest_reading_recorded_at_converted.must_be_kind_of String
      end
    end

    describe 'when latest_reading_recorded_at_raw is +10 time' do
      before do
        @reading.latest_reading_recorded_at_raw = '24 April 2018 at 3:30:00 pm AEST'
      end

      it 'converts it to UTC' do
        @reading.latest_reading_recorded_at_converted.must_equal '2018-04-24 05:30:00 +0000'
      end
    end

    describe 'when latest_reading_recorded_at_raw is +10 time an incorrectly marked GMT' do
      before do
        @reading.latest_reading_recorded_at_raw = 'April 24, 2018 3:30:00 PM GMT'
      end

      it 'reads it as +10 time and converts it to UTC' do
        @reading.latest_reading_recorded_at_converted.must_equal '2018-04-24 05:30:00 +0000'
      end
    end

    describe 'when latest_reading_recorded_at_raw is +10 time an incorrectly marked AEDT' do
      before do
        @reading.latest_reading_recorded_at_raw = '24 April 2018 3:30:00 pm AEDT'
      end

      it 'reads it as +10 time and converts it to UTC' do
        @reading.latest_reading_recorded_at_converted.must_equal '2018-04-24 05:30:00 +0000'
      end

      describe 'without a padded day number' do
        before do
          @reading.latest_reading_recorded_at_raw = 'April 7, 2018 1:00:00 AM GMT'
        end

        it 'converts it successfully' do
          @reading.latest_reading_recorded_at_converted.must_equal '2018-04-06 15:00:00 +0000'
        end
      end
    end
  end

  describe '#serialize' do
    it 'returns a hash with key names for a new AqmRecord' do
      reading = Aqm::Reading.new(location_name: 'foo')
      reading.scraped_at = Time.utc(2018, 4, 25, 17, 35)
      reading.pm2_5_concentration = 1
      reading.pm10_concentration = 2
      reading.co_concentration = 3
      reading.no2_concentration = 4
      reading.differential_temperature_lower = 5
      reading.differential_temperature_upper = 6
      reading.wind_speed = 7
      reading.wind_direction = 8
      reading.sigma = 9
      reading.latest_reading_recorded_at_raw = '24 April 2018 3:30:00 pm AEDT'

      reading.serialize.must_equal(
        location_name: 'foo',
        scraped_at: Time.utc(2018, 4, 25, 17, 35),
        latest_reading_recorded_at: '2018-04-24 05:30:00 +0000',
        latest_reading_recorded_at_raw: '24 April 2018 3:30:00 pm AEDT',
        pm2_5_concentration_ug_per_m3: 1,
        pm10_concentration_ug_per_m3: 2,
        co_concentration_ppm: 3,
        no2_concentration_ppm: 4,
        differential_temperature_lower_deg_c: 5,
        differential_temperature_upper_deg_c: 6,
        wind_speed_metres_per_second: 7,
        wind_direction_deg_true_north: 8,
        sigma_deg_true_north: 9
      )
    end
  end
end
