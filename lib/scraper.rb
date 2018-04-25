# frozen_string_literal: true

require 'capybara/poltergeist'
require_relative 'reading'
require_relative '../database'

# Very basic encapsulation of our scraper code so we can begin to test methods
class Scraper
  def self.run!
    new.run!
  end

  def run!
    capybara = Capybara::Session.new(:poltergeist)

    capybara.visit('http://airodis.ecotech.com.au/westconnex/')

    readings = []

    capybara.all('#sidebar table').each do |table|
      readings << Aqm::Reading.new(
        location_name: format_location_name_for_table(table)
      )
    end

    readings.each do |reading|
      capybara.find('header').click_link(reading.location_name)

      reading.scraped_at = Time.now.to_s
      reading.latest_reading_recorded_at_raw = presence(capybara.find('table thead').text.split('at: ').last)

      key_rows = capybara.all('tbody th').map { |th| tableize(th.text) }
      value_rows = capybara.all('tbody td').map { |td| extract_value(td.text) }
      measurements = key_rows.zip(value_rows).to_h

      reading.pm2_5_concentration = measurements['pm2_5_concentration']
      reading.pm10_concentration = measurements['pm10_concentration']
      reading.co_concentration = measurements['co_concentration']
      reading.no2_concentration = measurements['no2_concentration']
      reading.differential_temperature_lower = measurements['differential_temperature_lower']
      reading.differential_temperature_upper = measurements['differential_temperature_upper']
      reading.wind_speed = measurements['wind_speed']
      reading.wind_direction = measurements['wind_direction']
      reading.sigma = measurements['sigma']

      AqmRecord.create(reading.serialize)
    end
  end

  def format_location_name_for_table(table_elm)
    text = table_elm.find('thead').text
    name = text.split(' ')[0...-1].collect(&:capitalize).join(' ')
    name + ' AQM'
  end

  def tableize(string)
    string.downcase.gsub('- ', '').gsub(/(\.| )/, '_')
  end

  def extract_value(string)
    presence(string.split(' ').first)
  end

  # Checks for the presence of a reading, returns nil when there is no reading
  def presence(reading)
    reading == '-' ? nil : reading
  end
end
