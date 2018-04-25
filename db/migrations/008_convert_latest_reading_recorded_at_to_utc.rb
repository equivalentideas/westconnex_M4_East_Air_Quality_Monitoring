# frozen_string_literal: true

require_relative '../../lib/reading'

Sequel.migration do
  up do
    from(:aqm_records).all.each do |record|
      next unless record[:latest_reading_recorded_at]
      reading = Aqm::Reading.new
      reading.latest_reading_recorded_at_raw = record[:latest_reading_recorded_at]

      record.update(
        latest_reading_recorded_at: reading.latest_reading_recorded_at_converted
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
