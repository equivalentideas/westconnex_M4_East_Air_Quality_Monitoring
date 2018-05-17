#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/aqm_record'
require_relative 'lib/aqm_sites'
require_relative 'lib/aqm_reading'

AQM_SITES.each do |site|
  aqm_reading = AqmReading.new(
    location_name: site.location_name,
    raw_data: site.json,
    scraped_at: Time.now
  )
  AqmRecord.create(aqm_reading.data)
end
