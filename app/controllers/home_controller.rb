class HomeController < ApplicationController
  def index
    res = []
    Member.all.each do |member|
      res << member.as_json(:include => :parties).merge(:city => member.city.as_json)
    end
    gon.members = res.to_json
  end
end
