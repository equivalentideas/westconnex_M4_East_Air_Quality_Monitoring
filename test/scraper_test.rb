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
end
