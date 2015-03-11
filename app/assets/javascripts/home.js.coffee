$ ->


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


  return if typeof(google) is 'undefined'
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
    update_parties_map(city_ratios, city, coordinate)
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
    relevant_votes = city.votes.map((vote)-> if vote.party.name in defaults then vote.amount else 0)
    total_votes_in_city = relevant_votes.reduce((prev,current)-> prev + current )
    # console.log("#{city.name}: #{total_votes_in_city}")

    city_ratios = {}
    for vote in city.votes
      if vote.party.name in defaults
        city_ratios[vote.party.name] = vote.amount / total_votes_in_city
    city_ratios

  get_city_weight = (city_ratios)->
    weight = 0
    for party, i in defaults
      weight += city_ratios[party] * (i+1)
    weight

  set_data = (data)->
    party_heatmap.setMap(map)
    party_heatmap.setData([])
    party_heatmap.set('gradient',  gradient)
    party_heatmap.setData(data)

  build_rational_cities_heat_map = (party) ->
    cities = JSON.parse(gon.cities)
    window.heatMapData = []


    window.weights = {}
    for city in cities
      coordinate = new google.maps.LatLng(city.lat, city.lng)

      city_ratios = get_city_ratios city
      
      # City weight
      weight = get_city_weight(city_ratios)
      add_marker(city_ratios, coordinate, city, weight)

      # console.log("#{city.name}: #{weight}")
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


    set_data heatMapData



  add_polimap = ->
    parties = document.createElement('poli-map')

    parties.addEventListener 'party-selected', (ev) ->
      p = ev.detail.party
      party_data = parties_map[p]
      set_data party_data
      console.log 'will change the map to ' + ev.detail.party

    parties.addEventListener 'show_right_left_map', (ev) ->
      set_data window.heatMapData
      console.log 'will show right left map'

    parties.parties = defaults
    # parties.parties = [
    #   'gil'
    #   'nir'
    #   'omer'
    #   'udi'
    #   'anat'
    # ]
    $(".parties").prepend parties

  $(document).on "map_loaded", ->

    parties_div = document.createElement("div")
    parties_div.classList.add "parties"
    document.querySelector("body").appendChild parties_div

    $(".parties input").eq(4).attr("checked","true")
    build_rational_cities_heat_map()
    add_polimap()
