# frozen_string_literal: true

require 'test_helper'

describe Monitor do
  describe '.count' do
    it 'counts the distinct locations from the aqm_records' do
      AqmRecord.create(location_name: 'Haberfield Public School')
      AqmRecord.create(location_name: 'Haberfield Public School')
      AqmRecord.create(location_name: 'Allen St')
      AqmRecord.create(location_name: 'Powells Creek')
      AqmRecord.create(location_name: 'Ramsay St')
      AqmRecord.create(location_name: 'St Lukes Park')
      AqmRecord.create(location_name: 'Concord Oval')

      Monitor.count.must_equal 6
    end
  end

  describe '.all' do
    before(:each) do
      AqmRecord.create(location_name: 'Haberfield Public School AQM')
      AqmRecord.create(location_name: 'Haberfield Public School AQM')
      AqmRecord.create(location_name: 'Allen St AQM')
      AqmRecord.create(location_name: 'Powells Creek AQM')
      AqmRecord.create(location_name: 'Ramsay St AQM')
      AqmRecord.create(location_name: 'St Lukes Park AQM')
      AqmRecord.create(location_name: 'Concord Oval AQM')
    end

    it 'returns Monitor objects' do
      Monitor.all.first.must_be_kind_of Monitor
    end

    it 'returns the alphabetically ordered Monitors for distinct location_names from aqm_records' do
      Monitor.all.map(&:name).must_equal [
        'Allen St AQM',
        'Concord Oval AQM',
        'Haberfield Public School AQM',
        'Powells Creek AQM',
        'Ramsay St AQM',
        'St Lukes Park AQM'
      ]
    end
  end

  describe '#name' do
    it { Monitor.new(name: 'Foo Bar').name.must_equal 'Foo Bar' }
  end

  describe '#display_name' do
    it { Monitor.new(name: 'Foo Bar AQM').display_name.must_equal 'Foo Bar' }
    it { Monitor.new(name: 'Foo AQM Bar').display_name.must_equal 'Foo AQM Bar' }
  end

  describe '#percentage_of_pm2_5_readings_over_8' do
    it 'returns' do
      AqmRecord.create(location_name: 'Foo Bar', pm2_5_concentration_ug_per_m3: 6)
      AqmRecord.create(location_name: 'Foo Bar', pm2_5_concentration_ug_per_m3: 9)
      AqmRecord.create(location_name: 'Foo Bar', pm2_5_concentration_ug_per_m3: 25)
      monitor = Monitor.new(name: 'Foo Bar')

      monitor.percentage_of_pm2_5_readings_over_8.must_equal 66.67
    end
  end
end
