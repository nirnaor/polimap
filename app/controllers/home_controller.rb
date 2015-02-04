class HomeController < ApplicationController
  def index
    gon.members = Member.all.to_json(:include => :parties, :include => :city)
  end
end
