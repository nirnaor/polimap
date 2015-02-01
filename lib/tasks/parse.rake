require 'nokogiri'
require 'open-uri'
namespace :parse do
  desc "TODO"
  task knesset: :environment do

    def parse_member(url)
      doc = Nokogiri::HTML(open(url))
      member_node = doc.css("td.Name")
      name_node = member_node.children[0]
      if name_node.nil?
        puts "BAD URL: #{url}"
        return
      end

      name = name_node.text.squish
      party = member_node.children[1].text.squish
      binding.pry
      puts "#{name}: #{party}"
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
    # parse_knesset(knesset_number)
    parse_member("http://www.knesset.gov.il/mk/heb/mk.asp?mk_individual_id_t=857")

  end

end
