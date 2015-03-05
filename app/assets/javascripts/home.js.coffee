$ ->
  window.defaults = {
    'הבית היהודי – מייסודם של האיחוד הלאומי והמפד”ל החדשה': "7f3b08"
    "הליכוד – תנועה לאומית ליברלית": "b35806"
    "יהדות התורה": "e08214"
    'התאחדות הספרדים שומרי תורה – תנועת ש”ס':"fdb863"
    "קדימה": "fee0b6"
    "יש עתיד":"f7f7f7"
    "התנועה בראשות ציפי לבני": "f7f7f7"
    "מפלגת העבודה הישראלית": "f7f7f7"
    "מרצ": "f7f7f7"
    "בלד":"542788"
    "חדש":"2d004b"
  }

  window.partries_gradients = {}


  sort_by_value = ( hash )->
    sortable = []
    sortable.push [v,k] for k, v of hash
    sortable.sort (a, b) ->  b[0]- a[0]




  window.parties_heatmaps = {}

  window.gradient = ['rgba(0, 255, 255, 0)',
  'rgba(0, 255, 255, 1)',
  'rgba(0, 191, 255, 1)',
  'rgba(0, 127, 255, 1)',
  'rgba(0, 63, 255, 1)',
  'rgba(0, 0, 255, 1)',
  'rgba(0, 0, 223, 1)',
  'rgba(0, 0, 191, 1)',
  'rgba(0, 0, 159, 1)',
  'rgba(0, 0, 127, 1)',
  'rgba(63, 0, 91, 1)',
  'rgba(127, 0, 63, 1)',
  'rgba(191, 0, 31, 1)',
  'rgba(255, 0, 0, 1)'
  ]


  checked_parties = ->
    $(".parties input:checked").map (el) ->
      @getAttribute("value")



  infowindow = new google.maps.InfoWindow(content: "bla bla")
  markers = []
  add_marker = (city_ratios, coordinate, city,weight)->
    # Markers and info window
    marker = new google.maps.Marker(
        position: coordinate
        map: map
        ratios: city_ratios
        city: city
        weight: weight
        visible: false
    )
    markers.push(marker)
    google.maps.event.addListener(marker, 'click', (a)-> 
      city = marker.city.name

      header = document.createElement("h1")
      header.innerHTML = "#{city}-#{weight}"

      ratios_elements = document.createElement("div")
      ratios_elements.classList.add "marker"
      ratios_elements.appendChild header

      sorted_ratios = sort_by_value(marker.ratios)
      for party_ratio in sorted_ratios
        name = document.createElement("label")
        name.innerHTML = party_ratio[1].substring(0,15)
        party = document.createElement("label")
        party.innerHTML = "#{(party_ratio[0]* 100).toString().substring(0,5)}%"

        container = document.createElement("div")
        container.classList.add "member"
        container.appendChild name
        container.appendChild party

        ratios_elements.appendChild container


      infowindow.close()
      infowindow = new google.maps.InfoWindow(content: ratios_elements)
      infowindow.open(map, marker)
    )


  get_city_ratios = (city) ->
    relevant_votes = city.votes.map((vote)-> if vote.party.name in _(defaults).keys() then vote.amount else 0)
    total_votes_in_city = relevant_votes.reduce((prev,current)-> prev + current )
    # console.log("#{city.name}: #{total_votes_in_city}")

    city_ratios = {}
    for vote in city.votes
      if vote.party.name in _(defaults).keys()
        city_ratios[vote.party.name] = vote.amount / total_votes_in_city
    city_ratios

  get_city_weight = (city_ratios)->
    weight = 0
    for party, i in _(defaults).keys()
      weight += city_ratios[party] * (i+1)
    weight

  build_rational_cities_heat_map = (party) ->
    cities = JSON.parse(gon.cities)
    heatMapData = []


    window.weights = {}
    for city in cities
      coordinate = new google.maps.LatLng(city.lat, city.lng)

      city_ratios = get_city_ratios city
      
      # City weight
      weight = get_city_weight(city_ratios)
      add_marker(city_ratios, coordinate, city, weight)

      console.log("#{city.name}: #{weight}")
      heatMapData.push({location: coordinate, weight: weight})

    meters = 12 * 1000
    projection = new MercatorProjection()
    window.party_heatmap = new  google.maps.visualization.HeatmapLayer(
      radius: projection.getNewRadius(map,meters)
    )
    google.maps.event.addListener(map, 'zoom_changed', () ->
      new_radius = projection.getNewRadius(map,meters)
      zoom_level = map.getZoom()
      console.log "zoom changed to #{zoom_level}- changing to radius: #{new_radius}"
      party_heatmap.setOptions(radius: new_radius)

      visible = zoom_level > 11
      markers.forEach (marker)-> marker.setVisible(visible)
    )

    party_heatmap.setMap(map)
    party_heatmap.setData([])
    party_heatmap.set('gradient',  gradient)
    party_heatmap.setData(heatMapData)


  build_members_heat_map = (relevant_members)->
    city_map = {}
    relevant_members.map (member)->
      city = member.city.name
      if city_map[city] is undefined
        city_map[city] = []
      city_map[city].push member

      

    heatMapData = []
    for city_name, city_members of city_map
      # Get the location of the first member (since locations are the same for members
      # in the same city)
      city = city_members[0].city
      coordinate = new google.maps.LatLng(city.lat, city.lng)
      heatMapData.push({location: coordinate, weight: city_members.length})
      
      add_marker(city_members, coordinate)

    heatmap = new  google.maps.visualization.HeatmapLayer(
      data: heatMapData
      radius: 20 * 40
    )
    # change_gradient()
    heatmap.setMap(map)
    heatmap.set('gradient', gradient)

  $(document).on "map_loaded", ->
    # build_members_heat_map JSON.parse(gon.members)
    $(".parties input").eq(4).attr("checked","true")
    build_rational_cities_heat_map()
