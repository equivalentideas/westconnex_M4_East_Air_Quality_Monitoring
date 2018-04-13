# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:aqm_records) do
      set_column_type :pm2_5_concentration_ug_per_m3, Float, using: 'pm2_5_concentration_ug_per_m3::double precision'
      set_column_type :pm10_concentration_ug_per_m3, Float, using: 'pm10_concentration_ug_per_m3::double precision'
      set_column_type :co_concentration_ppm, Float, using: 'co_concentration_ppm::double precision'
      set_column_type :no2_concentration_ppm, Float, using: 'no2_concentration_ppm::double precision'
      set_column_type :differential_temperature_lower_deg_c, Float, using: 'differential_temperature_lower_deg_c::double precision'
      set_column_type :differential_temperature_upper_deg_c, Float, using: 'differential_temperature_upper_deg_c::double precision'
      set_column_type :wind_speed_metres_per_second, Float, using: 'wind_speed_metres_per_second::double precision'
      set_column_type :wind_direction_deg_true_north, Float, using: 'wind_direction_deg_true_north::double precision'
      set_column_type :sigma_deg_true_north, Float, using: 'sigma_deg_true_north::double precision'
    end
  end
end
