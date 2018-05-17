# frozen_string_literal: true

require 'net/http'

# Air quality monitoring sites and their JSON data
Site = Struct.new(:location_name, :json_url) do
  def json
    Net::HTTP.get(URI(json_url))
  end
end

# Copied from http://airodis.ecotech.com.au/westconnex/settings.js
AQM_SITES = [
  Site.new('Haberfield Public School AQM', 'http://airodis.ecotech.com.au/AirodisReport/JobSubmit.ashx?report=West+Connex%5cWebsite%5cChandos+St+Summary.xml&format=json&seq=Chandos+St'),
  Site.new('Concord Oval AQM', 'http://airodis.ecotech.com.au/AirodisReport/JobSubmit.ashx?report=West+Connex%5cWebsite%5cConcord+Oval+Summary.xml&format=json&seq=Concord+Oval'),
  Site.new('Allen St AQM', 'http://airodis.ecotech.com.au/AirodisReport/JobSubmit.ashx?report=West+Connex%5cWebsite%5cPomeroy+St+Summary.xml&format=json&seq=Pomeroy+St'),
  Site.new('Powells Creek AQM', 'http://airodis.ecotech.com.au/AirodisReport/JobSubmit.ashx?report=West+Connex%5cWebsite%5cPowells+Creek+Summary.xml&format=json&seq=Powells+Creek'),
  Site.new('Ramsay St AQM', 'http://airodis.ecotech.com.au/AirodisReport/JobSubmit.ashx?report=West+Connex%5cWebsite%5cRamsay+St+Summary.xml&format=json&seq=Ramsay+St'),
  Site.new('St Lukes Park AQM', 'http://airodis.ecotech.com.au/AirodisReport/JobSubmit.ashx?report=West+Connex%5cWebsite%5cSt+Lukes+Park+Summary.xml&format=json&seq=St+Lukes+Park')
].freeze
