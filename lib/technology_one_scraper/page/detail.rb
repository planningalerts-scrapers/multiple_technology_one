# frozen_string_literal: true

module TechnologyOneScraper
  module Page
    # The page that shows detailed information about one application
    module Detail
      # TODO: Scrape more of what there is on the detail page
      def self.scrape(page)
        {
          address: page.at('td.headerColumn[contains("Address")] ~ td').inner_text,
          description: page.at('td.headerColumn[contains("Description")] ~ td').inner_text
        }
      end
    end
  end
end
