json.array!(@cities) do |city|
  json.extract! city, :id, :name, :lat, :lng
  json.url city_url(city, format: :json)
end
