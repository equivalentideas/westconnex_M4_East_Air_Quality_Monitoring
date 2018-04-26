# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:aqm_records) do
      set_column_type :latest_reading_recorded_at, DateTime, using: 'latest_reading_recorded_at::timestamp'
    end
  end
end
