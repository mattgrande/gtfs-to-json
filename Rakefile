require File.expand_path(File.dirname(__FILE__) + "/config/boot")
require File.expand_path(File.dirname(__FILE__) + '/gtfs-rt/gtfs-realtime.pb.rb')
require 'open-uri'
require 'rspec/core/rake_task'

task :default => :help

desc "Run specs"
task :spec do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = './spec/**/*_spec.rb'
  end
end

desc "Run IRB console with app environment"
task :console do
  puts "Loading development console..."
  system("irb -r ./config/boot.rb")
end

desc "Import all GTFS data"
task :import_gtfs do
  puts "Destroying..."
  Route.all.destroy
  Stop.all.destroy

  puts "Importing..."
  is_first_line = true
  CSV.foreach( File.expand_path(File.dirname(__FILE__) + '/gtfs/routes.txt' ) ) do |row|
    if is_first_line
      is_first_line = false
      next
    end

    r = Route.new
    r.route_id = row[5]
    r.route_number = row[8]
    r.route_name = row[8] + ' ' + row[0]
    r.text_color = row[2]
    r.bg_color = row[3]
    puts "Importing #{r.route_name} -> #{r.route_id}"
    r.save
  end

  is_first_line = true
  CSV.foreach( File.expand_path(File.dirname(__FILE__) + '/gtfs/stops.txt') ) do |row|
    if is_first_line
      is_first_line = false
      next
    end

    s = Stop.new
    s.stop_id = row[4]
    s.lat = row[0].to_f
    s.lon = row[3].to_f
    s.stop_code = row[2]
    s.stop_desc = row[7]
    s.stop_name = row[8]
    puts "Importing #{s.stop_id} -> #{s.stop_desc}"
    s.save
  end
end

task :download_buses do
  url = 'http://opendata.hamilton.ca/GTFS-RT/GTFS_VehiclePositions.pb'
  # while true
    puts 'Downloading vehicle positions...'
    data = FeedMessage.decode( open(url).read )
    puts 'Vehicle positions downloaded.'

    data.entity.each do |entity|
      next if entity.nil? or entity['vehicle'].nil?
      vehicle_position = entity['vehicle']
      vehicle  = vehicle_position['vehicle']
      position = vehicle_position['position']
      trip     = vehicle_position['trip']

      bus = Bus.first_or_create( :bus_number => vehicle['label'] )
      if ( bus.lat != position['latitude'] and bus.lng != position['longitude'] )
        bus.lat      = position['latitude']
        bus.lng      = position['longitude']
        bus.speed    = position['speed']
        bus.odometer = position['odometer']
        bus.bearing  = position['bearing']
        bus.route_id = trip['route_id']
        bus.trip_id  = trip['trip_id']

        bus.save
      end
    end
    # puts data.entity.length
  # end
end

task :bus_time do
  url = 'http://opendata.hamilton.ca/GTFS-RT/GTFS_TripUpdates.pb'
#   while true
    puts 'Downloading trip updates...'
    data = FeedMessage.decode( open(url).read )
    puts 'Trip updates downloaded.'

    data.entity.each do |entity|
      next if entity.nil?

      trip    = entity['trip_update']['trip']
      vehicle = entity['trip_update']['vehicle']
      updates = entity['trip_update']['stop_time_update']

      next if trip.nil? or vehicle.nil? or updates.nil?

      # Trip info
      trip_id  = trip['trip_id']
      route_id = trip['route_id']

      # Vehicle info
      bus_number = vehicle['label']

      updates.each do |update|
        # Currently arrival and departure times always seem to be the same.
        # So we'll just use arrival
        next if update['arrival'].nil?

        stop_id       = update['stop_id']
        status        = update['schedule_relationship']
        arrival_time  = update['arrival']['time']
        arrival_delay = update['arrival']

        trip_update = TripUpdate.first_or_create( :trip_id => trip_id, :stop_id => stop_id )
        trip_update.route_id      = route_id
        trip_update.bus_number    = bus_number
        trip_update.status        = status
        trip_update.arrival_time  = arrival_time
        trip_update.arrival_delay = arrival_delay

        trip_update.save
      end
    end
  # end
end

desc "Show help menu"
task :help do
  puts "Available rake tasks: "
  puts "rake console - Run a IRB console with all enviroment loaded"
  puts "rake spec - Run specs and calculate coverage"
end