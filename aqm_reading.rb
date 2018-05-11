# frozen_string_literal: true

require 'nokogiri'

# A reading comprising several measurements from an air quality monitoring site
class AqmReading
  attr_reader :raw_data, :location_name, :scraped_at

  # @param raw_data [String] HTML of page containing air quality measurements
  def initialize(raw_data:, location_name:, scraped_at:)
    @raw_data = Nokogiri::HTML(raw_data)
    @location_name = location_name
    @scraped_at = scraped_at
  end

  # Outputs a hash of all the data for this reading, suitable for saving to the database
  def data
    {
      location_name: location_name,
      scraped_at: scraped_at
    }
  end
end
