$ ->
  $(document).on "map_loaded", ->
    console.log "google maps is loaded", map
    console.log gon.members

    afula   = new google.maps.LatLng(32.613104, 35.284166)
    netanya = new google.maps.LatLng(32.327070, 34.857270)
    givataim = new google.maps.LatLng(32.072541, 34.809648)
    telaviv = new google.maps.LatLng(31.899121, 34.679601)

    weight = 10
    heatMapData = [
      {location: afula, weight: weight  }
      {location: telaviv, weight: weight * 12 }
      {location: givataim, weight: weight * 3 }
      {location: netanya, weight: weight  }
    ]
   
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
