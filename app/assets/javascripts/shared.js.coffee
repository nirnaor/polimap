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
