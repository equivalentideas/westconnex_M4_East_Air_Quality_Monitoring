#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'csv'
require './database'

get '/' do
  'Hello world!'
end

get '/csv' do
  content_type 'application/csv'
  attachment 'aqm_records.csv'
  CSV.generate do |csv|
    csv << AqmRecord.columns # Add header row
    AqmRecord.order(:scraped_at).all.each do |record|
      csv << record.values.values
    end
  end
end
