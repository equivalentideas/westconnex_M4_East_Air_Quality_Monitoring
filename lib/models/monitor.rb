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
end
