#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'csv'
require './config/app_config'

get '/' do
  @monitors = Monitor.all
  @monitor_locations = Monitor.all.map(&:display_name)

  erb :index, layout: false
end

get '/statistics' do
  sites = AqmRecord.select(:location_name).distinct.map(:location_name)
  @statistics = sites.map do |location_name|
    records = AqmRecord.where(location_name: location_name).order(:scraped_at)
    {
      location_name: location_name,
      first_record: records.first.scraped_at,
      record_count: records.count,
      recent: records.last(5),
      avg_pm2_5_concentration_ug_per_m3: records.where { pm2_5_concentration_ug_per_m3 >= 0 }.avg(:pm2_5_concentration_ug_per_m3).round(1),
      negatives_pm2_5_concentration_ug_per_m3: records.where { pm2_5_concentration_ug_per_m3 < 0 }.count,
      avg_pm10_concentration_ug_per_m3: records.where { pm10_concentration_ug_per_m3 >= 0 }.avg(:pm10_concentration_ug_per_m3).round(1),
      negatives_pm10_concentration_ug_per_m3: records.where { pm10_concentration_ug_per_m3 < 0 }.count,
      avg_co_concentration_ppm: records.where { co_concentration_ppm >= 0 }.avg(:co_concentration_ppm).round(2),
      negatives_co_concentration_ppm: records.where { co_concentration_ppm < 0 }.count,
      avg_no2_concentration_ppm: records.where { no2_concentration_ppm >= 0 }.avg(:no2_concentration_ppm).round(3),
      negatives_no2_concentration_ppm: records.where { no2_concentration_ppm < 0 }.count
    }
  end

  erb :statistics
end

# TODO: Move this to a helper
def csv_filename
  Time.now.strftime('%F_%H%M') + '_m4east_air_quality_monitors.csv'
end

get '/csv' do
  content_type 'application/csv'
  attachment csv_filename
  CSV.generate do |csv|
    csv << AqmRecord.columns # Add header row
    AqmRecord.order(:scraped_at).all.each do |record|
      csv << record.values.values
    end
  end
end
