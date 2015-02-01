require 'nokogiri'
require 'open-uri'
namespace :parse do
  desc "TODO"
  task knesset: :environment do

    def parse_member(url)
      puts url
    end


    def parse_knesset(knesset_number)
      base_url = "http://www.knesset.gov.il/mk/heb"
      url = "#{base_url}/mkindexbyknesset.asp?knesset=#{knesset_number}"
      # doc = Nokogiri::HTML(open('http://www.nokogiri.org/tutorials/installing_nokogiri.html'))
      doc = Nokogiri::HTML(open(url))

      doc.css(".MKIconM, .MKIconF").each do |link|
          member_link = link.children.css("a").first
          next if member_link.nil?
          link_url =  member_link.attributes["href"].value
          parse_member("#{base_url}/#{link_url}")
      end
    end



    knesset_number = 19
    parse_knesset(knesset_number)

  end

end
