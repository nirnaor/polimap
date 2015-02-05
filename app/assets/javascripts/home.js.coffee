$ ->
  add_class = (el, className) ->
    if (el.classList)
        el.classList.add(className)
    else
        el.className += ' ' + className

  checked_parties = ->
    $(".parties input:checked").map (el) ->
      @getAttribute("value")

  parties_legend = ->
    defaults = [
      "הליכוד – תנועה לאומית ליברלית",
      "יש עתיד",
      "מפלגת העבודה הישראלית",
      "הבית היהודי – מייסודם של האיחוד הלאומי והמפד”ל החדשה ",
      "התאחדות הספרדים שומרי תורה – תנועת ש”ס ",
      "יהדות התורה",
      "התנועה בראשות ציפי לבני",
      "בלד"
      "חדש",
      'הבית היהודי – מייסודם של האיחוד הלאומי והמפד”ל החדשה',
      "קדימה",
      "מרצ",
      'התאחדות הספרדים שומרי תורה – תנועת ש”ס'
    ]

    parties_div = document.createElement("div")
    add_class parties_div, "parties"
    all_parties = gon.parties
    all_parties.forEach (party)->
      return unless party.name in defaults
      party_div = document.createElement("div")
      add_class(party_div, "party")
      party_div.innerHTML = party.name.substring(0,30)
      party_div.setAttribute("party",party.name)
      checkbox = document.createElement("input")

      if party.name in defaults
        checkbox.setAttribute("checked", "true")
      checkbox.setAttribute("type", "checkbox")
      checkbox.setAttribute("value", party.name)
      party_div.appendChild checkbox
      checkbox.addEventListener "change", (ev)->
        p = @getAttribute "party"
        build_cities_heat_map(checked_parties())
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

  build_cities_heat_map = (relevant_parties) ->
    cities = JSON.parse(gon.cities)
    heatMapData = []


    for city in cities
      coordinate = new google.maps.LatLng(city.lat, city.lng)
      relevant_votes = city.votes.filter (vote)-> vote.party.name in relevant_parties

      # itterate on party votes and sum the up for now
      sum = 0
      mapped = relevant_votes.forEach (vote) ->  sum += vote.amount
      
      if sum > 0
        heatMapData.push({location: coordinate, weight: sum})

    heatmap.setData([])
    heatmap.setData(heatMapData)


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
      radius: 20 * 4
    )
    heatmap.setMap(map)

  $(document).on "map_loaded", ->
    window.heatmap = new  google.maps.visualization.HeatmapLayer(
      radius: 20 * 4
    )
    heatmap.setMap(map)
    # build_members_heat_map JSON.parse(gon.members)
    parties_legend()
    first_party = document.querySelector(".parties").children[0].getAttribute("party")
    build_cities_heat_map(checked_parties())
