# frozen_string_literal: true

Sequel.migration do
  up do
    [
      :latest_reading_recorded_at,
      :pm2_5_concentration_ug_per_m3,
      :pm10_concentration_ug_per_m3,
      :co_concentration_ppm,
      :no2_concentration_ppm,
      :differential_temperature_lower_deg_c,
      :differential_temperature_upper_deg_c,
      :wind_speed_metres_per_second,
      :wind_direction_deg_true_north,
      :sigma_deg_true_north
    ].each do |field|
      from(:aqm_records).where(field => '-').update(field => nil)
    end
  end
end
