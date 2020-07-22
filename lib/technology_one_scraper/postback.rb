# frozen_string_literal: true

module TechnologyOneScraper
  # Help with handling asp.net doPostBack
  module Postback
    # Implement a click on a link that understands stupid asp.net doPostBack
    def self.click(doc, page)
      js = doc["href"] || doc["onclick"]
      raise "Couldn't find one of the expected attributes" if js.nil?

      return if js =~ /return false;/

      # TODO: Just follow the link likes it's a normal link
      unless js =~ /javascript:__doPostBack\('(.*)','(.*)'\)/
        raise "Expected a javascript postback link here: #{js}"
      end

      form = page.form_with(id: "aspnetForm")
      form["__EVENTTARGET"] = Regexp.last_match(1)
      form["__EVENTARGUMENT"] = Regexp.last_match(2)
      form.submit
    end
  end
end
