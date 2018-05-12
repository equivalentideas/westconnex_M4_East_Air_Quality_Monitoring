#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'csv'
require './config/app_config'

get '/' do
  @monitors = Monitor.all
  @monitor_locations = Monitor.all.map { |m| m.name.sub(' AQM', '') }

  erb :index
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
