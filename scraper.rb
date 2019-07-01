#!/usr/bin/env ruby
Bundler.require

def scrape(authorities)
  exceptions = {}
  authorities.each do |authority_label|
    puts "\nCollecting feed data for #{authority_label}..."

    begin
      TechnologyOneScraper.scrape(authority_label) do |record|
        record["authority_label"] = authority_label.to_s
        TechnologyOneScraper.log(record)
        ScraperWiki.save_sqlite(["authority_label", "council_reference"], record)
      end
    rescue StandardError => e
      STDERR.puts "#{authority_label}: ERROR: #{e}"
      STDERR.puts e.backtrace
      exceptions[authority_label] = e
    end
  end
  exceptions
end

authorities = TechnologyOneScraper::AUTHORITIES.keys
puts "Scraping authorities: #{authorities.join(', ')}"
exceptions = scrape(authorities)

unless exceptions.empty?
  puts "\n***************************************************"
  puts "Now retrying authorities which earlier had failures"
  puts "***************************************************"

  exceptions = scrape(exceptions.keys)
end

unless exceptions.empty?
  raise "There were errors with the following authorities: #{exceptions.keys}. See earlier output for details"
end
