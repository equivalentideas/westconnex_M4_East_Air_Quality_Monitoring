# frozen_string_literal: true

require 'open-uri'
require 'json'
require_relative '../database'

# Very basic encapsulation of our scraper code so we can begin to test methods
class Scraper
  MONITOR_JSON_MAPPINGS = {
    'Chandos St' => 'Haberfield Public School AQM',
    'Concord Oval' => 'Concord Oval AQM',
    'Pomeroy St' => 'Allen St AQM',
    'Powells Creek' => 'Powells Creek AQM',
    'Ramsay St' => 'Ramsay St AQM',
    'St Lukes Park' => 'St Lukes Park AQM'
  }.freeze

  def self.run!
    new.run!
  end

  def run!
    MONITOR_JSON_MAPPINGS.each do |k, v|
      uri = URI.parse("http://airodis.ecotech.com.au/AirodisReport/JobSubmit.ashx?report=West+Connex%5cWebsite%5c#{ k.gsub(' ','+') }+summary.xml&format=json")
      json = JSON.parse(uri.open.read)
      values = json['Footer'].last[1..-1]

      AqmRecord.create(
        location_name: v,
        scraped_at: Time.now.to_s,
        latest_reading_recorded_at: '',
        pm2_5_concentration_ug_per_m3: extract_value(values[0]),
        pm10_concentration_ug_per_m3: extract_value(values[1]),
        co_concentration_ppm: extract_value(values[2]),
        no2_concentration_ppm: extract_value(values[3]),
        differential_temperature_lower_deg_c: extract_value(values[4]),
        differential_temperature_upper_deg_c: extract_value(values[5]),
        wind_speed_metres_per_second: extract_value(values[6]),
        wind_direction_deg_true_north: extract_value(values[7]),
        sigma_deg_true_north: extract_value(values[8])
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
    string.split(' ').first if string
  end

  # Checks for the presence of a reading, returns nil when there is no reading
  def presence(reading)
    reading&.eql?('-') ? nil : reading
  end
end
