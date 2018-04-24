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

    records = []

    capybara.all('#sidebar table').each do |table|
      records << {
        location_name: format_location_name_for_table(table)
      }
    end

    records.each do |record|
      capybara.find('header').click_link(record[:location_name])

      record[:scraped_at] = Time.now.to_s
      record[:latest_reading_recorded_at] = presence(capybara.find('table thead').text.split('at: ').last)
      record[:original_reading_datetime_string] = record[:latest_reading_recorded_at]

      key_rows = capybara.all('tbody th').map { |th| tableize(th.text) }
      value_rows = capybara.all('tbody td').map { |td| extract_value(td.text) }
      measurements = key_rows.zip(value_rows).to_h

      record[:pm2_5_concentration_ug_per_m3] = measurements['pm2_5_concentration']
      record[:pm10_concentration_ug_per_m3] = measurements['pm10_concentration']
      record[:co_concentration_ppm] = measurements['co_concentration']
      record[:no2_concentration_ppm] = measurements['no2_concentration']
      record[:differential_temperature_lower_deg_c] = measurements['differential_temperature_lower']
      record[:differential_temperature_upper_deg_c] = measurements['differential_temperature_upper']
      record[:wind_speed_metres_per_second] = measurements['wind_speed']
      record[:wind_direction_deg_true_north] = measurements['wind_direction']
      record[:sigma_deg_true_north] = measurements['sigma']

      AqmRecord.create(record)
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

  def convert_time(datetime_string)
    return unless datetime_string && !datetime_string.empty?
    time_with_utc = replace_false_timezone_with_utc(datetime_string)
    shift_time_back_ten_hours(Time.parse(time_with_utc))
  end

  private

  def replace_false_timezone_with_utc(datetime_string)
    time_parts = datetime_string.split
    time_parts.slice!(-1) unless time_parts[-1][/^(am|pm)$/i]
    time_parts << '+0000'
    time_parts.join ' '
  end

  def shift_time_back_ten_hours(time)
    time - (60 * 60 * 10)
  end
end
