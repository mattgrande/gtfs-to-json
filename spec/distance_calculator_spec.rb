describe DistanceCalculator do
  describe 'get_distance_from_lat_lon_in_km' do
    it 'should calculate the distance between King & James and King & Victoria' do
      # The distance is about 1064m, so let's test for that.
      dc = DistanceCalculator.new
      d = dc.get_distance_from_lat_lon_in_km( 43.2566802, -79.8690065, 43.2531339, -79.8568017 )
      expect( d.round(3) ).to eq( 1.064 )
    end
  end
end