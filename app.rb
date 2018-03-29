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
    csv << AqmRecord.attribute_names # Add header row
    AqmRecord.all.each do |record|
      csv << record.attributes.values
    end
  end
end
