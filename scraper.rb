require 'capybara/poltergeist'
require 'active_record'
require_relative 'database_config.rb'

def format_location_name_for_table(table_elm)
  text = table_elm.find('thead').text
  name = text.split(' ')[0...-1].collect(&:capitalize).join(' ')
  name + ' AQM'
end

def tableize(string)
  string.downcase.gsub('- ', '').gsub(/(\.| )/,'_')
end

class AqmRecord < ActiveRecord::Base; end

unless AqmRecord.table_exists?
  ActiveRecord::Schema.define do
    create_table :aqm_records do |t|
      t.string :location_name
      t.string :scraped_at
      t.string :latest_reading_recorded_at
      t.string :pm2_5_concentration
      t.string :pm10_concentration
      t.string :co_concentration
      t.string :no2_concentration
      t.string :differential_temperature_lower
      t.string :differential_temperature_upper
      t.string :wind_speed
      t.string :wind_direction
      t.string :sigma
    end
  end
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

  record.merge!(
    'scraped_at' => Time.now.to_s,
    'latest_reading_recorded_at' => capybara.find('table thead').text.split('at: ').last
  )

  key_rows = capybara.all('tbody th').map {|th| tableize(th.text) }
  value_rows = capybara.all('tbody td').map(&:text)

  record.merge!(key_rows.zip(value_rows).to_h)

  AqmRecord.create(record)
end
