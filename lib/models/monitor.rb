# frozen_string_literal: true

# The Air Quality Monitor that readings belong to
class Monitor
  attr_accessor :name

  def self.count
    AqmRecord.distinct(:location_name).count
  end

  def self.all
    AqmRecord.distinct(:location_name).select(:location_name).order(:location_name).collect do |record|
      new(name: record.values[:location_name])
    end
  end

  def initialize(name: nil)
    @name = name
  end

  def percentage_of_pm2_5_readings_over_8
    all_records = AqmRecord.where(location_name: name)
    with_pm25_over8 = all_records.where(
      Sequel.lit('pm2_5_concentration_ug_per_m3 > ?', 8)
    )

    (with_pm25_over8.count.to_f / all_records.count * 100).round(2)
  end
end
