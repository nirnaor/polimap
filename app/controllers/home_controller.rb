class HomeController < ApplicationController
  def index
    file = File.read("optimized_cities_only_big_parties.json")
    gon.cities = file
  end

  def nir
  end
  def polymer_test
  end


  def members_json
    unless Rails.cache.exist? :members
      res = []
      Member.all.each do |member|
        res << member.as_json(:include => :parties).merge(:city => member.city.as_json)
      end
      Rails.cache.write(:members,res.to_json)
    end
    Rails.cache.read :members
  end

  def cities_json
    unless Rails.cache.exist? :cities
    #   from_file = File.read("cities.json")
      res = []
      City.all.each do |city|
        city_json = city.as_json
        votes = []
        city.votes.each do |city_vote|
          votes << city_vote.as_json(:include => :party)
        end
        city_json = city_json.merge(:votes => votes)
        res << city_json
      end
      Rails.cache.write(:cities,res.to_json)
      # Rails.cache.write(:cities,from_file)
    end
    Rails.cache.read :cities
  end

end
