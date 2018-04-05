# frozen_string_literal: true

require 'test_helper'

describe Sinatra::Application do
  it 'should politely greet visitors' do
    get '/'
    last_response.body.must_include 'Hello world!'
  end

  describe 'the API' do
    before do
      AqmRecord.dataset.destroy
      AqmRecord.unrestrict_primary_key
      AqmRecord.create(
        id: 1,
        location_name: 'Haberfield Public School AQM',
        scraped_at: '2018-03-20 12:03:28 +1100',
        latest_reading_recorded_at: '20 March 2018 11:00:00 AM AEDT',
        pm2_5_concentration: '17.0 (µg/m³)',
        pm10_concentration: '44.1 (µg/m³)',
        co_concentration: '0.07 (ppm)',
        no2_concentration: '0.006 (ppm)',
        differential_temperature_lower: '26.9 (°C)',
        differential_temperature_upper: '25.8 (°C)',
        wind_speed: '3.0 (m/s)',
        wind_direction: '175.3 (°)',
        sigma: '31.3 (°)'
      )
      AqmRecord.create(
        id: 2,
        location_name: 'Allen St AQM',
        scraped_at: '2018-03-20 12:03:32 +1100',
        latest_reading_recorded_at: '20 March 2018 11:00:00 AM AEDT',
        pm2_5_concentration: '12.0 (µg/m³)',
        pm10_concentration: '48.4 (µg/m³)',
        co_concentration: '0.10 (ppm)',
        no2_concentration: '0.009 (ppm)',
        differential_temperature_lower: '27.1 (°C)',
        differential_temperature_upper: '26.7 (°C)',
        wind_speed: '2.8 (m/s)',
        wind_direction: '169.3 (°)',
        sigma: '32.2 (°)'
      )
    end

    it 'should supply a CSV of all of the data' do
      get '/csv'
      last_response.body.must_equal <<~CSV
        id,location_name,scraped_at,latest_reading_recorded_at,pm2_5_concentration,pm10_concentration,co_concentration,no2_concentration,differential_temperature_lower,differential_temperature_upper,wind_speed,wind_direction,sigma
        1,Haberfield Public School AQM,2018-03-20 12:03:28 +1100,20 March 2018 11:00:00 AM AEDT,17.0 (µg/m³),44.1 (µg/m³),0.07 (ppm),0.006 (ppm),26.9 (°C),25.8 (°C),3.0 (m/s),175.3 (°),31.3 (°)
        2,Allen St AQM,2018-03-20 12:03:32 +1100,20 March 2018 11:00:00 AM AEDT,12.0 (µg/m³),48.4 (µg/m³),0.10 (ppm),0.009 (ppm),27.1 (°C),26.7 (°C),2.8 (m/s),169.3 (°),32.2 (°)
      CSV
    end
  end
end
