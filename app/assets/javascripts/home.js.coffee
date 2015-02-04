$ ->
  $(document).on "map_loaded", ->
    console.log "google maps is loaded", map
    relevant_members =  JSON.parse(gon.members)

  
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

    heatmap = new  google.maps.visualization.HeatmapLayer(
      data: heatMapData
      radius: 20 * 4
    )
    heatmap.setMap(map)

    #myLatlng = new google.maps.LatLng(31.899121,34.679601)
#    marker = new (google.maps.Marker)(
#      position: myLatlng
#      animation: google.maps.Animation.DROP
#      icon: "http://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Likud_Logo.svg/200px-Likud_Logo.svg.png"
#      size: new google.maps.Size(20, 32),
#      map: map
#      title: 'Hello World!')
#
