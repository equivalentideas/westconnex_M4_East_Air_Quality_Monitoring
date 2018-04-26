# frozen_string_literal: true

Sequel.migration do
  up do
    from(:aqm_records).exclude(latest_reading_recorded_at: nil).each do |record|
      timezone_stripped = record[:latest_reading_recorded_at].gsub(/\b\S*$/, '+0000')
      converted_to_utc = Time.parse(timezone_stripped) - (60 * 60 * 10)

      record.update(
        latest_reading_recorded_at: converted_to_utc.to_s
      )

      from(:aqm_records).where(id: record[:id]).update(record)
    end
  end

  down do
    from(:aqm_records).all.each do |record|
      record.update(
        latest_reading_recorded_at: record[:latest_reading_recorded_at_raw]
      )

      from(:aqm_records).where(id: record[:id]).update(record)
    end
  end
end
