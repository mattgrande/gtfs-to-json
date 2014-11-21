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
end

# task :download_trip_updates do
#   url = 'http://opendata.hamilton.ca/GTFS-RT/GTFS_TripUpdates.pb'
#   # while true
#     puts 'Downloading...'
#     data = FeedMessage.decode( open(url).read )
#     puts 'Downloaded...'
#     data['entity'].each do |trip|
#       next if trip.nil? or trip['trip_update'].nil? or trip['trip_update']['trip'].nil?
#     end
#   # end
# end
# 
task :download_buses do
  url = 'http://opendata.hamilton.ca/GTFS-RT/GTFS_VehiclePositions.pb'
  # while true
    puts 'Downloading...'
    data = FeedMessage.decode( open(url).read )
    puts 'Downloaded...'

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

# task :bus_time do
#   url = 'http://opendata.hamilton.ca/GTFS-RT/GTFS_VehiclePositions.pb'
#   buses = Hash.new
#   while true
#     puts 'Downloading...'
#     data = FeedMessage.decode( open(url).read )

#     data.entity.each do |entity|
#       next if entity.nil? or entity['vehicle'].nil?
#       vehicle_position = entity['vehicle']
#       vehicle  = vehicle_position['vehicle']
#       position = vehicle_position['position']

#       if buses[ vehicle['label'] ]
#         if buses[ vehicle['label'] ][:lat] == position['latitude'] and buses[ vehicle['label'] ][:lng] == position['longitude']
#           # puts 'It\'s the same'
#         else
#           puts Time.now - buses[ vehicle['label'] ][:time]
#           buses[ vehicle['label'] ] = { 
#             :lat => position['latitude'],
#             :lng => position['longitude'],
#             :time => Time.now
#           }
#         end
#       # end
#       else
#         # puts 'no it doesn\'t'
#         buses[ vehicle['label'] ] = { 
#           :lat => position['latitude'],
#           :lng => position['longitude'],
#           :time => Time.now
#         }
#       end
#     end
#     sleep 1
#   end
# end

desc "Show help menu"
task :help do
  puts "Available rake tasks: "
  puts "rake console - Run a IRB console with all enviroment loaded"
  puts "rake spec - Run specs and calculate coverage"
end