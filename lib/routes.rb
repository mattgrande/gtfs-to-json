module GtfsToJson
  class Routes < Sinatra::Base

    get '/' do
      content_type :json
      @routes = Route.all
      @routes.to_json
    end

    # TODO - Determine if this should be Route Number or Route ID
    get '/:route_number' do
      content_type :json
      @routes = Route.all(:route_number => params[:route_number])
      @routes.to_json
    end

    get '/:route_number/buses' do
      content_type :json
      @routes = Route.all(:route_number => params[:route_number])
      @routes.to_json(methods: [ :buses ])
    end

  end
end
