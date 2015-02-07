class MercatorProjection
  TILE_SIZE = 256
  
  constructor: ->
    @pixelOrigin_ = new google.maps.Point(TILE_SIZE / 2, TILE_SIZE / 2)
    @pixelsPerLonDegree_ = TILE_SIZE / 360
    @pixelsPerLonRadian_ = TILE_SIZE / (2 * Math.PI)
 
  bound: (value, opt_min, opt_max) ->
    value = Math.max(value, opt_min) if opt_min is not null
    value = Math.min(value, opt_max) if opt_max is not null
    value
    
  degreesToRadians: (deg) ->
    deg * (Math.PI / 180)
    
  radiansToDegrees: (rad) ->
    rad / (Math.PI / 180)
    
  fromLatLngToPoint: (latLng, opt_point) ->
    point = opt_point || new google.maps.Point(0, 0);
    origin = @pixelOrigin_
 
    point.x = origin.x + latLng.lng() * @pixelsPerLonDegree_
 
    # NOTE(appleton): Truncating to 0.9999 effectively limits latitude to
    # 89.189.  This is about a third of a tile past the edge of the world
    # tile.
    siny = @bound(Math.sin(@degreesToRadians(latLng.lat())), - 0.9999, 0.9999)
    point.y = origin.y + 0.5 * Math.log((1 + siny) / (1 - siny)) * -@pixelsPerLonRadian_
    point
  
  fromPointToLatLng: (point) ->
    origin = me.pixelOrigin_
    lng = (point.x - origin.x) / @pixelsPerLonDegree_
    latRadians = (point.y - origin.y) / -@pixelsPerLonRadian_
    lat = @radiansToDegrees(2 * Math.atan(Math.exp(latRadians)) - Math.PI / 2)
    new google.maps.LatLng(lat, lng)
  
  #Google map instance
  #Radius is in meters
  getNewRadius: (map, radiusInMeters) ->  
    numTiles = 1 << map.getZoom()
    center = map.getCenter()
    moved = google.maps.geometry.spherical.computeOffset(center, 10000, 90); #1000 meters to the right
    initCoord = @fromLatLngToPoint(center)
    endCoord = @fromLatLngToPoint(moved)
    initPoint = new google.maps.Point(initCoord.x * numTiles, initCoord.y * numTiles)
    endPoint = new google.maps.Point(endCoord.x * numTiles, endCoord.y * numTiles)
    pixelsPerMeter = (Math.abs(initPoint.x - endPoint.x)) / 10000.0
    totalPixelSize = Math.floor(radiusInMeters * pixelsPerMeter)
    totalPixelSize
  
  #Export class
  window.MercatorProjection = MercatorProjection
