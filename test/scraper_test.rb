# frozen_string_literal: true

require 'test_helper'
require_relative '../lib/scraper'

describe Scraper do
  describe '#run!' do
    it 'creates AqmRecords from the JSON files' do
      VCR.use_cassette('airodis_echotech_com_au') do
        Scraper.new.run!

        AqmRecord.all.must_equal [
          {
            location_name: 'Haberfield Public School AQM',
            scraped_at: Time.now.to_s,
            latest_reading_recorded_at: Time.new(2018, 05, 14, 12, 40),
            pm2_5_concentration_ug_per_m3: 10.0,
            pm10_concentration_ug_per_m3: 8.1,
            co_concentration_ppm: 0.02,
            no2_concentration_ppm: 0.012,
            differential_temperature_lower_deg_c: 14.5,
            differential_temperature_upper_deg_c: 14.5,
            wind_speed_metres_per_second: 1.9,
            wind_direction_deg_true_north: 227.1,
            sigma_deg_true_north: 14.4
          },
          {
            location_name: 'Concord Oval AQM',
            scraped_at: Time.now.to_s,
            latest_reading_recorded_at: Time.new(2018, 05, 14, 12, 40),
            pm2_5_concentration_ug_per_m3: 3.0,
            pm10_concentration_ug_per_m3: 11.2,
            co_concentration_ppm: 0.41,
            no2_concentration_ppm: 0.017,
            differential_temperature_lower_deg_c: 15.1,
            differential_temperature_upper_deg_c: 15.1,
            wind_speed_metres_per_second: nil,
            wind_direction_deg_true_north: nil,
            sigma_deg_true_north: nil
          },
          {
            location_name: 'Allen St AQM',
            scraped_at: Time.now.to_s,
            latest_reading_recorded_at: Time.new(2018, 05, 14, 12, 40),
            pm2_5_concentration_ug_per_m3: 2.0,
            pm10_concentration_ug_per_m3: 9.1,
            co_concentration_ppm: 0.12,
            no2_concentration_ppm: 0.017,
            differential_temperature_lower_deg_c: 14.5,
            differential_temperature_upper_deg_c: 14.9,
            wind_speed_metres_per_second: 1.1,
            wind_direction_deg_true_north: 235.6,
            sigma_deg_true_north: 35.3
          },
          {
            location_name: 'Powells Creek AQM',
            scraped_at: Time.now.to_s,
            latest_reading_recorded_at: Time.new(2018, 05, 14, 12, 40),
            pm2_5_concentration_ug_per_m3: 5.0,
            pm10_concentration_ug_per_m3: 47.8,
            co_concentration_ppm: 0.12,
            no2_concentration_ppm: 0.024,
            differential_temperature_lower_deg_c: 15.0,
            differential_temperature_upper_deg_c: 14.9,
            wind_speed_metres_per_second: 1.2,
            wind_direction_deg_true_north: 250.3,
            sigma_deg_true_north: 14.9
          },
          {
            location_name: 'Ramsay St AQM',
            scraped_at: Time.now.to_s,
            latest_reading_recorded_at: Time.new(2018, 05, 14, 12, 40),
            pm2_5_concentration_ug_per_m3: 11.0,
            pm10_concentration_ug_per_m3: 8.7,
            co_concentration_ppm: 0.18,
            no2_concentration_ppm: 0.010,
            differential_temperature_lower_deg_c: 14.4,
            differential_temperature_upper_deg_c: 14.5,
            wind_speed_metres_per_second: nil,
            wind_direction_deg_true_north: nil,
            sigma_deg_true_north: nil
          },
          {
            location_name: 'St Lukes Park AQM',
            scraped_at: Time.now.to_s,
            latest_reading_recorded_at: Time.new(2018, 05, 14, 12, 40),
            pm2_5_concentration_ug_per_m3: 4.0,
            pm10_concentration_ug_per_m3: 10.9,
            co_concentration_ppm: 0.21,
            no2_concentration_ppm: 0.012,
            differential_temperature_lower_deg_c: 14.5,
            differential_temperature_upper_deg_c: 14.9,
            wind_speed_metres_per_second: 0.5,
            wind_direction_deg_true_north: 222.0,
            sigma_deg_true_north: 37.3
          }
        ]
      end
    end
  end

  describe '#extract_value' do
    it 'should remove units from the string' do
      Scraper.new.extract_value('9.0 (µg/m³)').must_equal '9.0'
    end

    it 'should be nil for blank values' do
      Scraper.new.extract_value('-').must_be_nil
    end
  end

  describe '#presence' do
    it 'should convert missing readings to nil' do
      Scraper.new.presence('-').must_be_nil
    end

    it 'should keep the reading intact when present' do
      Scraper.new.presence('123').must_equal '123'
    end
  end
end
