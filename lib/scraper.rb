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
      record[:latest_reading_recorded_at_raw] = presence(capybara.find('table thead').text.split('at: ').last)
      record[:latest_reading_recorded_at] = Scraper.new.convert_time(
        record[:latest_reading_recorded_at_raw]
      )

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
    shift_time_back_ten_hours(
      Time.parse(replace_trailing_timezone_with_utc(datetime_string))
    )
  end

  private

  def replace_trailing_timezone_with_utc(datetime_string)
    datetime_string.gsub(/\b\S*$/, '+0000')
  end

  def shift_time_back_ten_hours(time)
    time - (60 * 60 * 10)
  end
end
