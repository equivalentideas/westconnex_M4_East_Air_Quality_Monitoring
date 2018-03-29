#!/usr/bin/env ruby
# frozen_string_literal: true

require 'capybara/poltergeist'
require_relative 'database.rb'

def format_location_name_for_table(table_elm)
  text = table_elm.find('thead').text
  name = text.split(' ')[0...-1].collect(&:capitalize).join(' ')
  name + ' AQM'
end

def tableize(string)
  string.downcase.gsub('- ', '').gsub(/(\.| )/, '_')
end

def extract_value(string)
  string.split(' ').first
end

capybara = Capybara::Session.new(:poltergeist)

capybara.visit('http://airodis.ecotech.com.au/westconnex/')

records = []

capybara.all('#sidebar table').each do |table|
  records << {
    'location_name' => format_location_name_for_table(table)
  }
end

records.each do |record|
  capybara.find('header').click_link(record['location_name'])

  record['scraped_at'] = Time.now.to_s
  record['latest_reading_recorded_at'] = capybara.find('table thead').text.split('at: ').last

  key_rows = capybara.all('tbody th').map { |th| tableize(th.text) }
  value_rows = capybara.all('tbody td').map { |td| extract_value(td.text) }

  record.merge!(key_rows.zip(value_rows).to_h)

  AqmRecord.create(record)
end
