# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:aqm_records) do
      set_column_type :scraped_at, DateTime, using: 'scraped_at::timestamp'
    end
  end
end
