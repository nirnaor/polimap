$ ->

  build_heat_map = (relevant_members)->
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
      
      # Markers and info window
      infowindow = new google.maps.InfoWindow(content: "bla bla")
      marker = new google.maps.Marker(
          position: coordinate
          city: city_name
          map: map
          title: 'Uluru (Ayers Rock)'
      )
      google.maps.event.addListener(marker, 'click', (a)-> 
        window_position = new google.maps.LatLng(a.latLng.k, a.latLng.D)
        infowindow = new google.maps.InfoWindow(
          content: "NIRNAOR", position: window_position
        )
        infowindow.open(map)
      )

    heatmap = new  google.maps.visualization.HeatmapLayer(
      data: heatMapData
      radius: 20 * 4
    )
    heatmap.setMap(map)

  $(document).on "map_loaded", ->
    console.log "google maps is loaded", map
    relevant_members =  JSON.parse(gon.members)
    build_heat_map relevant_members
    #myLatlng = new google.maps.LatLng(31.899121,34.679601)
#    marker = new (google.maps.Marker)(
#      position: myLatlng
#      animation: google.maps.Animation.DROP
#      icon: "http://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Likud_Logo.svg/200px-Likud_Logo.svg.png"
#      size: new google.maps.Size(20, 32),
#      map: map
#      title: 'Hello World!')
#
