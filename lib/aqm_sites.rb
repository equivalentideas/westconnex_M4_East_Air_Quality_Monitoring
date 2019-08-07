# frozen_string_literal: true

require 'net/http'

# Air quality monitoring sites and their JSON data
Site = Struct.new(:location_name, :json_url) do
  def json
    Net::HTTP.get(URI(json_url))
  end
end

AQM_SITES = [
  # Copied from http://airodis.ecotech.com.au/westconnexm5new/settings.js
  Site.new('St Peters 3 (St Peters St) AQM', 'http://airodis.ecotech.com.au/AirodisReport/JobSubmit.ashx?report=West+Connex%5cM5%5cWebsite%5cSt+Peters+Public+School+Status.xml&format=json'),
  Site.new('Barton Park AQM', 'http://airodis.ecotech.com.au/AirodisReport/JobSubmit.ashx?report=West+Connex%5cM5%5cWebsite%5cBarton+Park+Status.xml&format=json'),
  Site.new('Arncliffe 1 (West Botany St) AQM', 'http://airodis.ecotech.com.au/AirodisReport/JobSubmit.ashx?report=West+Connex%5cM5%5cWebsite%5cArncliffe+West+Botany+Status.xml&format=json'),
  Site.new('Arncliffe 2 (Eve St) AQM', 'http://airodis.ecotech.com.au/AirodisReport/JobSubmit.ashx?report=West+Connex%5cM5%5cWebsite%5cArncliffe+Eve+St++Status.xml&format=json'),
  Site.new('St Peters 1 Campbell St) AQM', 'http://airodis.ecotech.com.au/AirodisReport/JobSubmit.ashx?report=West+Connex%5cM5%5cWebsite%5cSt+Peters+RMS+Status.xml&format=json'),
  Site.new('St Peters 2 (SPI) AQM', 'http://airodis.ecotech.com.au/AirodisReport/JobSubmit.ashx?report=West+Connex%5cM5%5cWebsite%5cSt+Peters+SPI+Status.xml&format=json'),
  Site.new('Kingsgrove 1 (MOC1) AQM', 'http://airodis.ecotech.com.au/AirodisReport/JobSubmit.ashx?report=West+Connex%5cM5%5cWebsite%5cKingsgrove+1+Status.xml&format=json'),
  Site.new('Kingsgrove 2 (Kinsgrove Rd) AQM', 'http://airodis.ecotech.com.au/AirodisReport/JobSubmit.ashx?report=West+Connex%5cM5%5cWebsite%5cKingsgrove+2+Status.xml&format=json')
].freeze
