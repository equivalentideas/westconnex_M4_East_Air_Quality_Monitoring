# frozen_string_literal: true

# FIXME: This migration currently results in data loss, where the conversation
#        to float doesn't work for many of the records, and NULL is saved.
#        I don't know why this is yet, so have added a raise at the top here to
#        ensure that this isn't run accidentally in production before being fixed :D
raise
Sequel.migration do
  up do
    alter_table(:aqm_records) do
      add_column :pm2_5_concentration_ug_per_m3_flt, Float
      add_column :pm10_concentration_ug_per_m3_flt, Float
      add_column :co_concentration_ppm_flt, Float
      add_column :no2_concentration_ppm_flt, Float
      add_column :differential_temperature_lower_deg_c_flt, Float
      add_column :differential_temperature_upper_deg_c_flt, Float
      add_column :wind_speed_metres_per_second_flt, Float
      add_column :wind_direction_deg_true_north_flt, Float
      add_column :sigma_deg_true_north_flt, Float
    end

    # This does not work
    from(:aqm_records).all.each do |record|
      record.update(
        pm2_5_concentration_ug_per_m3_flt: record[:pm2_5_concentration_ug_per_m3].to_f,
        pm10_concentration_ug_per_m3_flt: record[:pm10_concentration_ug_per_m3].to_f,
        co_concentration_ppm_flt: record[:co_concentration_ppm].to_f,
        no2_concentration_ppm_flt: record[:no2_concentration_ppm].to_f,
        differential_temperature_lower_deg_c_flt: record[:differential_temperature_lower_deg_c].to_f,
        differential_temperature_upper_deg_c_flt: record[:differential_temperature_upper_deg_c].to_f,
        wind_speed_metres_per_second_flt: record[:wind_speed_metres_per_second].to_f,
        wind_direction_deg_true_north_flt: record[:wind_direction_deg_true_north].to_f,
        sigma_deg_true_north_flt: record[:sigma_deg_true_north].to_f
      )
    end

    drop_column :aqm_records, :pm2_5_concentration_ug_per_m3
    drop_column :aqm_records, :pm10_concentration_ug_per_m3
    drop_column :aqm_records, :co_concentration_ppm
    drop_column :aqm_records, :no2_concentration_ppm
    drop_column :aqm_records, :differential_temperature_lower_deg_c
    drop_column :aqm_records, :differential_temperature_upper_deg_c
    drop_column :aqm_records, :wind_speed_metres_per_second
    drop_column :aqm_records, :wind_direction_deg_true_north
    drop_column :aqm_records, :sigma_deg_true_north

    alter_table(:aqm_records) do
      rename_column :pm2_5_concentration_ug_per_m3_flt, :pm2_5_concentration_ug_per_m3
      rename_column :pm10_concentration_ug_per_m3_flt, :pm10_concentration_ug_per_m3
      rename_column :co_concentration_ppm_flt, :co_concentration_ppm
      rename_column :no2_concentration_ppm_flt, :no2_concentration_ppm
      rename_column :differential_temperature_lower_deg_c_flt, :differential_temperature_lower_deg_c
      rename_column :differential_temperature_upper_deg_c_flt, :differential_temperature_upper_deg_c
      rename_column :wind_speed_metres_per_second_flt, :wind_speed_metres_per_second
      rename_column :wind_direction_deg_true_north_flt, :wind_direction_deg_true_north
      rename_column :sigma_deg_true_north_flt, :sigma_deg_true_north
    end
  end

  down do
    alter_table(:aqm_records) do
      set_column_type :pm2_5_concentration_ug_per_m3, :text
      set_column_type :pm10_concentration_ug_per_m3, :text
      set_column_type :co_concentration_ppm, :text
      set_column_type :no2_concentration_ppm, :text
      set_column_type :differential_temperature_lower_deg_c, :text
      set_column_type :differential_temperature_upper_deg_c, :text
      set_column_type :wind_speed_metres_per_second, :text
      set_column_type :wind_direction_deg_true_north, :text
      set_column_type :sigma_deg_true_north, :text
    end
  end
end
