module VotesHelper
  def party_link(vote)
    link_to vote.party.name, party_url(vote.party)
  end
  def city_link(vote)
    link_to vote.city.name, city_url(vote.city)
  end

end
