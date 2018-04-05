# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
Sequel.migration do
  up do
    def extract_value(string)
      string&.split(' ')&.first
    end

    from(:aqm_records).all.each do |record|
      record.update(
        pm2_5_concentration: extract_value(record[:pm2_5_concentration]),
        pm10_concentration: extract_value(record[:pm10_concentration]),
        co_concentration: extract_value(record[:co_concentration]),
        no2_concentration: extract_value(record[:no2_concentration]),
        differential_temperature_lower: extract_value(record[:differential_temperature_lower]),
        differential_temperature_upper: extract_value(record[:differential_temperature_upper]),
        wind_speed: extract_value(record[:wind_speed]),
        wind_direction: extract_value(record[:wind_direction]),
        sigma: extract_value(record[:sigma])
      )

      from(:aqm_records).where(id: record[:id]).update(record)
    end
  end

  down do
    from(:aqm_records).all.each do |record|
      record.update(
        pm2_5_concentration: record[:pm2_5_concentration] + ' (µg/m³)',
        pm10_concentration: record[:pm10_concentration] + ' (µg/m³)',
        co_concentration: record[:co_concentration] + ' (ppm)',
        no2_concentration: record[:no2_concentration] + ' (ppm)',
        differential_temperature_lower: record[:differential_temperature_lower] + ' (°C)',
        differential_temperature_upper: record[:differential_temperature_upper] + ' (°C)',
        wind_speed: record[:wind_speed] + ' (m/s)',
        wind_direction: record[:wind_direction] + ' (°)',
        sigma: record[:sigma] + ' (°)'
      )

      from(:aqm_records).where(id: record[:id]).update(record)
    end
  end
end
# rubocop:enable Metrics/LineLength
