require 'spec_helper'

describe GtfsToJson::Routes do

  before do
    r1 = Route.create(:route_id => '2908', :route_name => '05 DELAWARE', :route_number => '05')
    r2 = Route.create(:route_id => '2838', :route_name => '05 DELAWARE', :route_number => '05')

    b1 = Bus.create(:route_id => '2908', :bus_number => 'Bus One')
    b2 = Bus.create(:route_id => '2838', :bus_number => 'Bus Two')
  end

  def app
    @app ||= GtfsToJson::Routes
  end

  describe "GET '/routes'" do
    it "should be successful" do
      get '/'
      expect(last_response).to be_ok
    end

    it "should be JSON" do
      get '/'
      expect(last_response.content_type).to eq('application/json')
    end

    it "should have one route" do
      get '/'
      routes = JSON.parse( last_response.body )
      expect( routes.length ).to eq( 2 )
    end

    it "should have the proper data" do
      get '/'
      routes = JSON.parse( last_response.body )
      expect( routes[0]['route_name'] ).to eq( '05 DELAWARE' )
    end
  end

  describe "GET '/routes/:route_number'" do
    it "should be successful" do
      get '/05'
      expect(last_response).to be_ok
    end

    it "should be JSON" do
      get '/05'
      expect(last_response.content_type).to eq('application/json')
    end

    it "should have one route" do
      get '/05'
      routes = JSON.parse( last_response.body )
      expect( routes.length ).to eq( 2 )
    end

    it "should have the proper data" do
      get '/05'
      routes = JSON.parse( last_response.body )
      expect( routes[0]['route_name'] ).to eq( '05 DELAWARE' )
    end
  end

  describe "GET '/routes/:route_number/buses'" do
    it 'should have buses' do
      get '/05/buses'
      expect(last_response).to be_ok
    end

    it "should be JSON" do
      get '/05/buses'
      expect(last_response.content_type).to eq('application/json')
    end

    it "should have one bus" do
      get '/05/buses'
      routes = JSON.parse( last_response.body )
      expect( routes[0]['buses'].length ).to eq( 1 )
    end

    it "should have the proper data" do
      get '/05/buses'
      routes = JSON.parse( last_response.body )
      expect( routes[0]['buses'][0]['bus_number'] ).to eq( 'Bus Two' )
    end
  end
end
