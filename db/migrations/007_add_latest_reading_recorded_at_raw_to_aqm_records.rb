# frozen_string_literal: true

Sequel.migration do
  up do
    add_column :aqm_records, :latest_reading_recorded_at_raw, String

    from(:aqm_records).all.each do |record|
      record.update(
        latest_reading_recorded_at_raw: record[:latest_reading_recorded_at]
      )

      from(:aqm_records).where(id: record[:id]).update(record)
    end
  end

  down do
    drop_column :aqm_records, :latest_reading_recorded_at_raw
  end
end
