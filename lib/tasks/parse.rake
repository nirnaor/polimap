require 'nokogiri'
require 'open-uri'
namespace :parse do
  desc "TODO"
  task knesset: :environment do
    url = "http://www.knesset.gov.il/mk/heb/mkindexbyknesset.asp?knesset=19"
    # doc = Nokogiri::HTML(open('http://www.nokogiri.org/tutorials/installing_nokogiri.html'))
    doc = Nokogiri::HTML(open(url))


    doc.css(".MKIconM, .MKIconF").each do |link|
        member_link = link.children.css("a").first
        next if member_link.nil?
        puts member_link.attributes["href"].value
    end
  end

end
