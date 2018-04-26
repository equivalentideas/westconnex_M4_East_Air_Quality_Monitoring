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

  describe '#latest_reading_recorded_at' do
    subject { AqmRecord.new }

    describe 'backing up the raw value' do
      before do
        subject.latest_reading_recorded_at = '24 April 2018 at 3:30:00 pm AEST'
      end

      it 'should be a String' do
        subject.latest_reading_recorded_at_raw.must_be_kind_of String
      end

      it 'should save the value exactly as it was passed' do
        subject.latest_reading_recorded_at_raw.must_equal '24 April 2018 at 3:30:00 pm AEST'
      end
    end

    describe 'blank value' do
      before do
        subject.latest_reading_recorded_at = ''
      end

      it 'should be recorded as nil' do
        subject.latest_reading_recorded_at.must_be_nil
      end

      it 'should record the raw backup as nil' do
        subject.latest_reading_recorded_at_raw.must_be_nil
      end
    end

    describe 'clearing attribute after setting it' do
      before do
        subject.latest_reading_recorded_at = '24 April 2018 at 3:30:00 pm AEST'
        subject.latest_reading_recorded_at = ''
      end

      it 'should be recorded as nil' do
        subject.latest_reading_recorded_at.must_be_nil
      end

      it 'should record the raw backup as nil' do
        subject.latest_reading_recorded_at_raw.must_be_nil
      end
    end

    describe 'empty string' do
      before do
        subject.latest_reading_recorded_at = ' '
      end

      it 'should be recorded as nil' do
        subject.latest_reading_recorded_at.must_be_nil
      end

      it 'should record the raw backup as nil' do
        subject.latest_reading_recorded_at_raw.must_be_nil
      end
    end

    describe 'when date and time is +10 time' do
      before do
        subject.latest_reading_recorded_at = '24 April 2018 at 3:30:00 pm AEST'
      end

      it 'converts it to UTC' do
        subject.latest_reading_recorded_at.must_equal '2018-04-24 05:30:00 +0000'
      end
    end

    describe 'when date and time is +10 time an incorrectly marked GMT' do
      before do
        subject.latest_reading_recorded_at = 'April 24, 2018 3:30:00 PM GMT'
      end

      it 'reads it as +10 time and converts it to UTC' do
        subject.latest_reading_recorded_at.must_equal '2018-04-24 05:30:00 +0000'
      end
    end

    describe 'when date and time is +10 time an incorrectly marked AEDT' do
      before do
        subject.latest_reading_recorded_at = '24 April 2018 3:30:00 pm AEDT'
      end

      it 'reads it as +10 time and converts it to UTC' do
        subject.latest_reading_recorded_at.must_equal '2018-04-24 05:30:00 +0000'
      end

      describe 'without a padded day number' do
        before do
          subject.latest_reading_recorded_at = 'April 7, 2018 1:00:00 AM GMT'
        end

        it 'converts it successfully' do
          subject.latest_reading_recorded_at.must_equal '2018-04-06 15:00:00 +0000'
        end
      end
    end
  end
end
