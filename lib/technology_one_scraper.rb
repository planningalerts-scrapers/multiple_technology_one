# frozen_string_literal: true

require "technology_one_scraper/version"
require "technology_one_scraper/authorities"
require "technology_one_scraper/postback"
require "technology_one_scraper/table"
require "technology_one_scraper/page/detail"
require "technology_one_scraper/page/index"

require "scraperwiki"
require "mechanize"

# Scrape the technology one system
module TechnologyOneScraper
  def self.scrape(authority)
    raise "Unexpected authority: #{authority}" unless AUTHORITIES.key?(authority)

    scrape_period(AUTHORITIES[authority]) do |record|
      yield record
    end
  end

  def self.scrape_and_save(authority)
    scrape(authority) do |record|
      TechnologyOneScraper.save(record)
    end
  end

  def self.save(record)
    log(record)
    ScraperWiki.save_sqlite(["council_reference"], record)
  end

  def self.log(record)
    puts "Saving record " + record["council_reference"] + ", " + record["address"]
  end

  # TODO: Instead of relying on hardcoded periods add support for general date ranges
  def self.url_period(base_url, period, webguest = "P1.WEBGUEST")
    params = {
      "Field" => "S",
      "Period" => period,
      "r" => webguest,
      "f" => "$P1.ETR.SEARCH.S#{period}"
    }
    "#{base_url}/P1/eTrack/eTrackApplicationSearchResults.aspx?#{params.to_query}"
  end

  def self.scrape_period(
    url:, period:, webguest: "P1.WEBGUEST", disable_ssl_certificate_check: false,
    australian_proxy: false
  )
    agent = Mechanize.new
    agent.verify_mode = OpenSSL::SSL::VERIFY_NONE if disable_ssl_certificate_check

    if australian_proxy
      # On morph.io set the environment variable MORPH_AUSTRALIAN_PROXY to
      # http://morph:password@au.proxy.oaf.org.au:8888 replacing password with
      # the real password.
      agent.agent.set_proxy(ENV["MORPH_AUSTRALIAN_PROXY"])
    end

    # TODO: Get rid of this extra agent
    agent_detail_page = Mechanize.new
    agent_detail_page.verify_mode = OpenSSL::SSL::VERIFY_NONE if disable_ssl_certificate_check

    page = agent.get(url_period(url, period, webguest))

    while page
      Page::Index.scrape(page, webguest) do |record|
        if record[:council_reference].nil? ||
           record[:address].nil? ||
           record[:description].nil? ||
           record[:date_received].nil?
          # We need more information. We can get this from the detail page
          detail_page = agent_detail_page.get(record[:info_url])
          record_detail = Page::Detail.scrape(detail_page)
          record = record.merge(record_detail)
          # TODO: Check that we have enough now
        end

        yield(
          "council_reference" => record[:council_reference],
          "address" => record[:address],
          "description" => record[:description],
          "info_url" => record[:info_url],
          "date_scraped" => Date.today.to_s,
          "date_received" => record[:date_received]
        )
      end
      page = Page::Index.next(page)
    end
  end
end
