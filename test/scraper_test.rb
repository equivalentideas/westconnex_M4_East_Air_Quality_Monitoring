# frozen_string_literal: true

require 'test_helper'
require_relative '../lib/scraper'

describe Scraper do
  describe '#extract_value' do
    it 'should remove units from the string' do
      Scraper.new.extract_value('9.0 (µg/m³)').must_equal '9.0'
    end
  end
end
