require 'json'

module GtfsToJson
  class Stops < Sinatra::Base

    get '/' do
      content_type :json
      @stops = Stop.all
      @stops.to_json
    end

    get '/nearby/:lat/:lon' do
      stops = Stop.all
      out = ''
      stops.each do |s|
        d = get_distance_from_lat_lon_in_km( params[:lat].to_f, params[:lon].to_f, s.lat, s.lon )
        s.distance = d
        out += "#{s.stop_name}, #{s.lat}, #{s.lon}, #{d}<br/>"
      end
      stops.sort! { |a,b| a.distance <=> b.distance }

      # Only return stops within 1km or the 10 closest stops, whichever is more.
      prev_dist = 0
      closest_stops = []
      stops.each do |s|
        break if s.distance > 1 and closest_stops.length >= 10
        closest_stops << s
      end

      closest_stops.to_json( methods: [ :distance ] )
    end
  end
end
