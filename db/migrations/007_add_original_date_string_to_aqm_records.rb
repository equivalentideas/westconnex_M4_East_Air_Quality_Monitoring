# frozen_string_literal: true

Sequel.migration do
  change do
    add_column :aqm_records, :original_reading_datetime_string, String

    from(:aqm_records).all.each do |record|
      record.update(
        original_reading_datetime_string: record[:latest_reading_recorded_at]
      )

      from(:aqm_records).where(id: record[:id]).update(record)
    end
  end
end
