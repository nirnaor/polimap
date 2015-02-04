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
      puts "#{name}: #{party}"
      city = get_city(doc)
      location = get_location(city)
    end


    def get_city(doc)
      # TODO: Find out how to parse the city. Currently I'll use this
      [ "תל אביב", "עפולה", "מטולה", "באר שבע", "לוד", "רמלה", "בית שאן", "ירושלים", "חיפה", "נתיבות", "שדרות" ].sample
    end

    def get_location(city)
      require 'addressable/uri'

      geocode_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{city}&key=AIzaSyAkaFB8bvQfKhDhQAlY4uVmcD9Xg7i9zdA"
      geocode_uri = Addressable::URI.parse(geocode_url)


      require "net/https"
      require "uri"

      uri = URI.parse(geocode_uri.normalize)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)
      response.body
      response["header-here"] # All headers are lowercase
      res = JSON.parse(response.body)
      coordinate = res["results"][0]["geometry"]["location"]
      puts coordinate
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
    # parse_member("http://www.knesset.gov.il/mk/heb/mk.asp?mk_individual_id_t=857")
    city = get_city(nil)
    get_location(city)

  end

end
