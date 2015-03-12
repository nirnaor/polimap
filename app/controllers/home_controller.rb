class HomeController < ApplicationController
  def index
    gon.cities = cities_json
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
      logger.info "reading from file system"
      file = File.read("optimized_cities_only_big_parties.json")
      Rails.cache.write(:cities,file)
      # Rails.cache.write(:cities,from_file)
    end
    Rails.cache.read :cities
  end

end
