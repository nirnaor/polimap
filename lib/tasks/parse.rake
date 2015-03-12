require 'nokogiri'
require 'open-uri'
namespace :parse do
  desc "TODO"
  task knesset: :environment do
    knesset_number = 19
    parse_knesset(knesset_number)
    # parse_member("http://www.knesset.gov.il/mk/heb/mk.asp?mk_individual_id_t=857")
  end

  task file: :environment do
    cities = Rails.cache.read :cities
    cities_hash = JSON.parse(cities)

    res = []
    cities_hash.each do |city|
      city_json = {:name =>  city["name"], :lat => city["lat"],
                   :lng => city["lng"] }
      votes = []
      city["votes"].each do |city_vote|
        votes << { :amount => city_vote["amount"],
                   :party => city_vote["party"]["name"] }
      end
      city_json[:votes] = votes
      res << city_json
    end
    File.write("optimized_cities.json", res.to_json)
  end

  task votes: :environment do
    require 'csv'
    filename = "#{Rails.root}/lib/tasks/expc_replaced2csvnocitycodes.csv"
    csv_array = CSV.foreach(filename)

    # Removing the first item from parties since it's effecting the matrix structure
    parties = csv_array.first[1..-1]
    vote_counter = 0


    csv_array.to_a[1..-1].each do |city_votes|
      city_name = city_votes.shift
      city_votes.each_with_index do |vote,vote_index|
        party_vote = city_votes[vote_index]
        party_name = parties[vote_index]

        vote_counter += 1
        puts "#{vote_counter}-#{city_name}:#{party_name}-#{party_vote}"
        vote = Vote.create(:amount => party_vote)
        vote.city = city_by city_name
        vote.party = party_by party_name
        vote.save
      end
    end
  end




  def parse_knesset(knesset_number)
    base_url = "http://www.knesset.gov.il/mk/heb"
    url = "#{base_url}/mkindexbyknesset.asp?knesset=#{knesset_number}"
    # doc = Nokogiri::HTML(open('http://www.nokogiri.org/tutorials/installing_nokogiri.html'))
    doc = Nokogiri::HTML(open(url))

    links = doc.css(".MKIconM, .MKIconF")
    links.each_with_index do |link,index|
        member_link = link.children.css("a").first
        next if member_link.nil?
        link_url =  member_link.attributes["href"].value
        puts "#{index}/#{links.size()}"
        parse_member("#{base_url}/#{link_url}")
    end
  end

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
    city = parse_city(doc)
    save(name, party, city)
  end


  def parse_city(doc)
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
    if res["status"] == "OK"
      return res["results"][0]["geometry"]["location"]
    end
    puts "No location was found for #{city}"
    {}
  end

  def save(name, party_name, city_name)
    member = Member.find_or_create_by(:name => name)
    party = party_by(party_name)
    member.parties.append party

    city = city_by city_name
    member.city = city
    member.save
  end

  def party_by(party_name)
    Party.find_or_create_by(:name => party_name)
  end


  def city_by(city_name)
    city = City.find_by_name(city_name) || City.new(:name => city_name)
    if city.new_record?
      location = get_location(city_name)
      city.lat = location["lat"]
      city.lng = location["lng"]
      city.save
    end
    city
  end


end
