# A simple regression test
# Simulates a fixed external website using data from fixtures
# Checks that the data is as expected

require 'vcr'
require 'scraperwiki'
require 'yaml'
require 'timecop'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end

File.delete("./data.sqlite") if File.exist?("./data.sqlite")

VCR.use_cassette("scraper", record: :new_episodes) do
  Timecop.freeze(Date.new(2019,5,15)) do
    require "./scraper"
  end
end

expected = if File.exist?("fixtures/expected.yml")
             YAML.load(File.read("fixtures/expected.yml"))
           else
             []
           end
results = ScraperWiki.select("* from data order by council_reference")

unless results == expected
  File.open("fixtures/expected.yml", "w") do |f|
    f.write(results.to_yaml)
  end
  raise "Failed"
end
puts "Succeeded"
