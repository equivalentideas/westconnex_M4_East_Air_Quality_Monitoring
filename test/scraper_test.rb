# frozen_string_literal: true

require 'test_helper'
require_relative '../lib/scraper'

describe Scraper do
  describe '#extract_value' do
    it 'should remove units from the string' do
      Scraper.new.extract_value('9.0 (µg/m³)').must_equal '9.0'
    end

    it 'should be nil for blank values' do
      Scraper.new.extract_value('-').must_be_nil
    end
  end

  describe '#presence' do
    it 'should convert missing readings to nil' do
      Scraper.new.presence('-').must_be_nil
    end

    it 'should keep the reading intact when present' do
      Scraper.new.presence('123').must_equal '123'
    end
  end

  describe '#convert_time' do
    it 'should parse a string containing an incorrectly marked +10 time and convert it to UTC' do
      Scraper.new.convert_time('March 16, 2018 8:00:00 AM GMT').to_s.must_equal '2018-03-15 22:00:00 +0000'
      Scraper.new.convert_time('March 30, 2018 11:30:00 AM GMT').to_s.must_equal '2018-03-30 01:30:00 +0000'
      Scraper.new.convert_time('April 10, 2018 4:10:00 PM GMT').to_s.must_equal '2018-04-10 06:10:00 +0000'
      Scraper.new.convert_time('April 23, 2018 10:00:00 PM GMT').to_s.must_equal '2018-04-23 12:00:00 +0000'
      Scraper.new.convert_time('April 24, 2018 3:30:00 PM GMT').to_s.must_equal '2018-04-24 05:30:00 +0000'
      Scraper.new.convert_time('24 April 2018 at 3:30:00 pm AEST').to_s.must_equal '2018-04-24 05:30:00 +0000'
      Scraper.new.convert_time('24 April 2018 3:30:00 pm AEDT').to_s.must_equal '2018-04-24 05:30:00 +0000'
    end

    it 'should be a Time' do
      Scraper.new.convert_time('March 16, 2018 8:00:00 AM GMT').must_be_kind_of Time
    end
  end
end
