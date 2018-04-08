#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'csv'
require './database'

get '/' do
  'Hello world!'
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
    AqmRecord.all.each do |record|
      csv << record.values.values
    end
  end
end
