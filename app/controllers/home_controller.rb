class HomeController < ApplicationController
  def index
    gon.members = members_json
  end


  def members_json
    res = []
    Member.all.each do |member|
      res << member.as_json(:include => :parties).merge(:city => member.city.as_json)
    end
    res.to_json
  end
end
