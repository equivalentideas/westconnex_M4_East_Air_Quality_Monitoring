# frozen_string_literal: true

require 'capybara/poltergeist'
require_relative '../database'

# Very basic encapsulation of our scraper code so we can begin to test methods
class Scraper
  def self.run!
    new.run!
  end

  def run!
    capybara = Capybara::Session.new(:poltergeist)

    capybara.visit('http://airodis.ecotech.com.au/westconnex/')

    location_names = capybara.all('#sidebar table').map do |table|
      format_location_name_for_table(table)
    end

    location_names.each do |location_name|
      capybara.find('header').click_link(location_name)

      key_rows = capybara.all('tbody th').map { |th| tableize(th.text) }
      value_rows = capybara.all('tbody td').map { |td| extract_value(td.text) }
      measurements = key_rows.zip(value_rows).to_h

      AqmRecord.create(
        location_name: location_name,
        scraped_at: Time.now.to_s,
        latest_reading_recorded_at: presence(capybara.find('table thead').text.split('at: ').last),
        pm2_5_concentration_ug_per_m3: measurements['pm2_5_concentration'],
        pm10_concentration_ug_per_m3: measurements['pm10_concentration'],
        co_concentration_ppm: measurements['co_concentration'],
        no2_concentration_ppm: measurements['no2_concentration'],
        differential_temperature_lower_deg_c: measurements['differential_temperature_lower'],
        differential_temperature_upper_deg_c: measurements['differential_temperature_upper'],
        wind_speed_metres_per_second: measurements['wind_speed'],
        wind_direction_deg_true_north: measurements['wind_direction'],
        sigma_deg_true_north: measurements['sigma']
      )
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
