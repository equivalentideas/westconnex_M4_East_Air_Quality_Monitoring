# frozen_string_literal: true

require 'test_helper'
require_relative '../aqm_reading'

describe AqmReading do
  subject do
    fixture_file = File.read(File.join(File.dirname(__FILE__), 'fixtures/haberfield.html'))
    AqmReading.new(raw_data: fixture_file)
  end

  it 'reads the file' do
    p subject
  end
end
