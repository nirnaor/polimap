json.array!(@votes) do |vote|
  json.extract! vote, :id, :amount, :city_id, :party_id
  json.url vote_url(vote, format: :json)
end
