$ ->
  add_class = (el, className) ->
    if (el.classList)
        el.classList.add(className)
    else
        el.className += ' ' + className

  parties_legend = ->
    parties_div = document.createElement("div")
    add_class parties_div, "parties"
    all_parties = gon.parties
    all_parties.forEach (party)->
      party_div = document.createElement("div")
      add_class(party_div, "party")
      party_div.innerHTML = party.name
      party_div.setAttribute("party",party.name)
      party_div.addEventListener "click", (ev)-> console.log this.getAttribute "party"
      parties_div.appendChild party_div

    document.querySelector("body").appendChild parties_div


  infowindow = new google.maps.InfoWindow(content: "bla bla")
  add_marker = (city_members, coordinate)->
    # Markers and info window
    marker = new google.maps.Marker(
        position: coordinate
        map: map
        members: city_members
    )
    google.maps.event.addListener(marker, 'click', (a)-> 
      city = marker.members[0].city.name

      header = document.createElement("h1")
      header.innerHTML = city

      members_elements = document.createElement("div")
      add_class(members_elements, "marker")
      members_elements.appendChild header
      city_members.forEach (item,i) ->
        name = document.createElement("label")
        name.innerHTML = item.name
        party = document.createElement("a")
        party.innerHTML = item.parties[0].name.substring(0, 30)

        container = document.createElement("div")
        add_class(container, "member")
        container.appendChild name
        container.appendChild party

        members_elements.appendChild container


      infowindow.content = members_elements
      infowindow.open(map, marker)
    )

  build_cities_heat_map = (cities) ->
    heatMapData = []

    relevant_party_name = "הרשימה הערבית המאוחדת"
    relevant_party_name = "הליכוד – תנועה לאומית ליברלית"
    console.log relevant_party_name
    for city in cities
      coordinate = new google.maps.LatLng(city.lat, city.lng)
      party_vote = city.votes.filter (vote)-> vote.party.name == relevant_party_name
      if party_vote.length > 0
        console.log(city.name, party_vote[0].amount)
        heatMapData.push({location: coordinate, weight: party_vote[0].amount})

    heatmap = new  google.maps.visualization.HeatmapLayer(
      data: heatMapData
      radius: 20 * 4
    )
    heatmap.setMap(map)


  build_members_heat_map = (relevant_members)->
    city_map = {}
    relevant_members.map (member)->
      city = member.city.name
      if city_map[city] is undefined
        city_map[city] = []
      city_map[city].push member

      
    console.log city_map

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
      radius: 20 * 4
    )
    heatmap.setMap(map)

  $(document).on "map_loaded", ->
    # build_members_heat_map JSON.parse(gon.members)
    build_cities_heat_map(JSON.parse(gon.cities))
    parties_legend()
