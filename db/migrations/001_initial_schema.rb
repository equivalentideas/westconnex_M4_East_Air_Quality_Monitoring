# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:aqm_records) do
      primary_key :id, type: :Bignum
      String :location_name
      String :scraped_at
      String :latest_reading_recorded_at
      String :pm2_5_concentration
      String :pm10_concentration
      String :co_concentration
      String :no2_concentration
      String :differential_temperature_lower
      String :differential_temperature_upper
      String :wind_speed
      String :wind_direction
      String :sigma
    end
  end
end
