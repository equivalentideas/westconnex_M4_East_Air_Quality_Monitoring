#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'csv'
require_relative 'lib/aqm_record'

get '/' do
  @locations = AqmRecord.distinct(:location_name)
                        .select(:location_name)
                        .map { |l| l.values[:location_name].sub(' AQM', '') }
  @locations_count = @locations.count

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
