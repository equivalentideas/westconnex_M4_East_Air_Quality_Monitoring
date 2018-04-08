# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:aqm_records) do
      rename_column :pm2_5_concentration, :pm2_5_concentration_ug_per_m3
      rename_column :pm10_concentration, :pm10_concentration_ug_per_m3
      rename_column :co_concentration, :co_concentration_ppm
      rename_column :no2_concentration, :no2_concentration_ppm
      rename_column :differential_temperature_lower, :differential_temperature_lower_deg_c
      rename_column :differential_temperature_upper, :differential_temperature_upper_deg_c
      rename_column :wind_speed, :wind_speed_metres_per_second
      rename_column :wind_direction, :wind_direction_deg_true_north
      rename_column :sigma, :sigma_deg_true_north
    end
  end
end
