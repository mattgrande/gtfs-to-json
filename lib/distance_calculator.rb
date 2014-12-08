class DistanceCalculator
  R = 6371

  # This script calculates great-circle distances between the two points using the ‘Haversine’ formula.
  def get_distance_from_lat_lon_in_km( lat1, lon1, lat2, lon2 )
    dLat = deg_to_rad( lat2-lat1 )
    dLon = deg_to_rad( lon2-lon1 )

    a = Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.cos(deg_to_rad(lat1)) * Math.cos(deg_to_rad(lat2)) *
      Math.sin(dLon/2) * Math.sin(dLon/2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    d = R * c # Distance in km
    return d
  end

private
  def deg_to_rad( deg )
    deg * (Math::PI/180)
  end
end