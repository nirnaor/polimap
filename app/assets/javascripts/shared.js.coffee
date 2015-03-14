window.defaults = [
  'הבית היהודי – מייסודם של האיחוד הלאומי והמפד”ל החדשה',
  "הליכוד – תנועה לאומית ליברלית",
  "יהדות התורה",
  'התאחדות הספרדים שומרי תורה – תנועת ש”ס',
  "קדימה",
  "יש עתיד",
  "התנועה בראשות ציפי לבני",
  "מפלגת העבודה הישראלית",
  "מרצ",
  "בלד",
  "חדש"
]

window.party_multipliers = {
  'הבית היהודי – מייסודם של האיחוד הלאומי והמפד”ל החדשה': 3000
  "הליכוד – תנועה לאומית ליברלית": 3200
  "יהדות התורה": 3400
  'התאחדות הספרדים שומרי תורה – תנועת ש”ס': 3600
  "קדימה": 140
  "יש עתיד": 120
  "התנועה בראשות ציפי לבני": 100
  "מפלגת העבודה הישראלית": 80
  "מרצ": 60
  "בלד": 40
  "חדש": 20
}

window.sort_by_value = ( hash )->
  sortable = []
  sortable.push [v,k] for k, v of hash
  sortable.sort (a, b) ->  b[0]- a[0]


window.parties_map ={}
for party in defaults
  parties_map[party] = []

window.update_parties_map = (ratios, city, coordinate)->
  sorted_ratios = sort_by_value(ratios)
  for element, index in sorted_ratios
    party_name = element[1]
    party_grade = sorted_ratios.length - index
    parties_map[party_name].push({location: coordinate, weight: party_grade})


window.sum_array = (array)->
  array.reduce((prev,current)-> prev + current )


window.calculate_total_voters_in_country = (cities)->
  all_cities_votes_arrays = cities.map (city) ->
    city.votes.map((vote)-> if vote.party in defaults then vote.amount else 0)
  
  sum_in_all_cities = all_cities_votes_arrays.map (vote_array) ->
    sum_array(vote_array)

  result = sum_array(sum_in_all_cities)
  console.log("Total voters: #{result}")
  result

window.add_social = ->
    social = $("<div class='polimap-social'>")
    url ="https://polimap.herokuapp.com"
    facebook_share = $("<div class='fb-share-button' data-href='#{url}' data-layout='button_count'></div>")
    facebook_like = $("<div class='fb-like' data-href='#{url}' data-layout='button_count' data-action='like' data-show-faces='true'></div>")
    social.prepend facebook_share
    social.prepend facebook_like
    $("#twitter-widget-0").remove().appendTo(social)

    $(".parties").append social

