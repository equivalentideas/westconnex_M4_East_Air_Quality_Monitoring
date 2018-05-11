# frozen_string_literal: true

require 'test_helper'
require_relative '../aqm_reading'

describe AqmReading do
  subject do
    haberfield_html = File.read(File.join(File.dirname(__FILE__), 'fixtures/haberfield.html'))
    AqmReading.new(raw_data: haberfield_html)
  end

  it 'reads the file' do
    p subject
  end
end
