module GtfsToJson
  class Buses < Sinatra::Base

    #configure do
      # set app specific settings
      # for example different view folders
    #end

    get '/' do
      content_type :json

      # Get all buses that have been updated in the past 10 minutes.
      @buses = Bus.all(:updated_at.gt => (Time.now - (10*60)))
      @buses.to_json
    end

    get '/:bus_number' do
    	content_type :json

      @bus = Bus.first(:bus_number => params[:bus_number])
      @bus.to_json
    end

  end
end
