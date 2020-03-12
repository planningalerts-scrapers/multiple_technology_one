# frozen_string_literal: true

require "active_support/core_ext/hash"

module TechnologyOneScraper
  module Page
    # A list of results of a search
    module Index
      def self.scrape(page, webguest = "P1.WEBGUEST")
        results = if page.search("table.grid").count > 1
                    # If there are multiple tables we have results laid out differently
                    page.search("table.grid").map do |table|
                      result = {}
                      table.search("tr").each do |tr|
                        key = tr.search("td")[0].inner_text.strip
                        value = tr.search("td")[1].inner_text.strip
                        result[key] = value
                      end
                      result
                    end
                  else
                    table = page.at("table.grid")
                    raise "Couldn't find table" if table.nil?

                    Table.extract_table(table)
                  end
        results.each do |row|
          normalised = row.map { |k, v| [normalise_name(k, v), v] }.to_h

          params = {
            # The first two parameters appear to be required to get the
            # correct authentication to view the page without a login or session
            "r" => webguest,
            "f" => "$P1.ETR.APPDET.VIW",
            "ApplicationId" => normalised[:council_reference]
          }
          info_url = "eTrackApplicationDetails.aspx?#{params.to_query}"
          yield(
            # For some reason we're getting doubling up of backslash. Hack around this.
            council_reference: normalised[:council_reference].gsub("\\\\", "\\"),
            address: normalised[:address],
            description: normalised[:description]&.squeeze(" "),
            info_url: (page.uri + info_url).to_s,
            date_received: Date.strptime(normalised[:date_received], "%d/%m/%Y").to_s
          )
        end
      end

      # Handles all the variants of the column names and handles them all to
      # transform them to a standard name that we use here
      def self.normalise_name(name, value)
        case name
        when "Application Link", "ID", "Application Number", "Application ID",
             "Application", "Permit No."
          :council_reference
        when "Lodgement Date", "Lodged", "Submitted Date", "Date Received"
          :date_received
        when "Description", "Proposal"
          :description
        when "Formatted Address", "Property Address", "Address", "Site Address"
          :address
        when "Group Description", "Group"
          :group_description
        when "Category Description", "Category", "Classification"
          :category_description
        when "Applicant Names", "Applicant", "Applicant Name(s)", "Applicant Details"
          :applicant_names
        when "Status", "Stage/Decision", "Decision", "Current Stage or Decision", "Stage"
          :status
        when "Application Type", "Application Group"
          :application_type
        when "Project Type"
          :project_type
        when "Details"
          # This can contain address and description but not in a consistent
          # order which makes thing tricky
          :details
        when "Work Commenced"
          :word_commenced
        when "Determined Date", "Date Determined"
          :determined_date
        when "Ward"
          :ward
        when "Development Cost", "Estimated Cost"
          :development_cost
        when "Priority"
          :priority
        else
          raise "Unknown name #{name} with value #{value}"
        end
      end

      def self.next(page)
        i = extract_current_page_no(page)
        link = find_link_for_page_number(page, i + 1)
        Postback.click(link, page) if link
      end

      def self.extract_current_page_no(page)
        page.search("tr.pagerRow").search("td span").inner_text.to_i
      end

      # Find the link to the given page number (if it's there)
      def self.find_link_for_page_number(page, number)
        links = page.search("tr.pagerRow").search("td a, td span")
        # Let's find the link with the required page
        texts = links.map(&:inner_text)
        number_texts = texts.reject { |t| t == "..." }
        max_page = number_texts.max_by(&:to_i).to_i
        min_page = number_texts.min_by(&:to_i).to_i
        if number == min_page - 1 && texts[0] == "..."
          links[0]
        elsif number >= min_page && number <= max_page
          links.find { |l| l.inner_text == number.to_s }
        elsif number == max_page + 1 && texts[-1] == "..."
          links[-1]
        end
      end
    end
  end
end
