# frozen_string_literal: true

require 'capybara/poltergeist'
require_relative '../database'
require_relative 'aqm_reading'

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

      aqm_reading = AqmReading.new(
        location_name: location_name,
        scraped_at: Time.now.to_s,
        raw_data: capybara.html
      )

      AqmRecord.create(aqm_reading.data)
    end
  end

  def format_location_name_for_table(table_elm)
    text = table_elm.find('thead').text
    name = text.split(' ')[0...-1].collect(&:capitalize).join(' ')
    name + ' AQM'
  end
end
