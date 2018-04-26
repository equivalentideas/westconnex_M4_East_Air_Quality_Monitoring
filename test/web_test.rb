# frozen_string_literal: true

require 'test_helper'

describe Sinatra::Application do
  it 'should politely greet visitors' do
    get '/'
    last_response.body.must_include 'Hello world!'
  end

  describe 'the API' do
    before do
      AqmRecord.unrestrict_primary_key
      AqmRecord.create(
        id: 1,
        location_name: 'Haberfield Public School AQM',
        scraped_at: '2018-03-20 12:03:32 +1100',
        latest_reading_recorded_at: '20 March 2018 11:00:00 AM AEDT',
        pm2_5_concentration_ug_per_m3: '17.0',
        pm10_concentration_ug_per_m3: '44.1',
        co_concentration_ppm: '0.07',
        no2_concentration_ppm: '0.006',
        differential_temperature_lower_deg_c: '26.9',
        differential_temperature_upper_deg_c: '25.8',
        wind_speed_metres_per_second: '3.0',
        wind_direction_deg_true_north: '175.3',
        sigma_deg_true_north: '31.3',
        latest_reading_recorded_at_raw: '20 March 2018 11:00:00 AM AEDT'
      )
      AqmRecord.create(
        id: 2,
        location_name: 'Allen St AQM',
        scraped_at: '2018-03-20 12:03:28 +1100',
        latest_reading_recorded_at: '20 March 2018 11:00:00 AM AEDT',
        pm2_5_concentration_ug_per_m3: '12.0',
        pm10_concentration_ug_per_m3: '48.4',
        co_concentration_ppm: '0.10',
        no2_concentration_ppm: '0.009',
        differential_temperature_lower_deg_c: '27.1',
        differential_temperature_upper_deg_c: '26.7',
        wind_speed_metres_per_second: '2.8',
        wind_direction_deg_true_north: '169.3',
        sigma_deg_true_north: '32.2',
        latest_reading_recorded_at_raw: '20 March 2018 11:00:00 AM AEDT'
      )
    end

    it 'should supply a CSV of all of the data' do
      get '/csv'
      last_response.body.must_equal <<~CSV
        id,location_name,scraped_at,latest_reading_recorded_at,pm2_5_concentration_ug_per_m3,pm10_concentration_ug_per_m3,co_concentration_ppm,no2_concentration_ppm,differential_temperature_lower_deg_c,differential_temperature_upper_deg_c,wind_speed_metres_per_second,wind_direction_deg_true_north,sigma_deg_true_north,latest_reading_recorded_at_raw
        2,Allen St AQM,2018-03-20 01:03:28 UTC,2018-03-20 01:00:00 +0000,12.0,48.4,0.1,0.009,27.1,26.7,2.8,169.3,32.2,20 March 2018 11:00:00 AM AEDT
        1,Haberfield Public School AQM,2018-03-20 01:03:32 UTC,2018-03-20 01:00:00 +0000,17.0,44.1,0.07,0.006,26.9,25.8,3.0,175.3,31.3,20 March 2018 11:00:00 AM AEDT
      CSV
    end

    it 'should have a useful filename' do
      Timecop.freeze(Time.new(2018, 1, 1, 12, 34)) do
        get '/csv'
        last_response.header['Content-Disposition'].must_include '2018-01-01_1234_m4east_air_quality_monitors.csv'
      end
    end

    describe 'csv_filename' do
      it 'should include the date and time the file was downloaded' do
        Timecop.freeze(Time.new(2018, 1, 1, 12, 34)) do
          csv_filename.must_equal '2018-01-01_1234_m4east_air_quality_monitors.csv'
        end
      end
    end
  end
end
