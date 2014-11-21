require 'spec_helper'

describe GtfsToJson::Buses do

  before do
    b     = Bus.create(:bus_number => '2908')
    b_old = Bus.create(:bus_number => '1579')
    b_old.update!(updated_at: Time.now - (5*60*60)) # Last updated 5 hours ago
  end

  def app
    @app ||= GtfsToJson::Buses
  end

  describe "GET '/buses'" do
    it "should be successful" do
      get '/'
      expect(last_response).to be_ok
    end

    it "should be JSON" do
      get '/'
      expect(last_response.content_type).to eq('application/json')
    end

    it "should have one bus" do
      get '/'
      buses = JSON.parse( last_response.body )
      expect( buses.length ).to eq( 1 )
    end

    it "should have the proper data" do
      get '/'
      buses = JSON.parse( last_response.body )
      expect( buses[0]['bus_number'] ).to eq( '2908' )
    end

    it 'should not fetch old buses' do
    	get '/'
      expect( last_response.body ).not_to include( '1579' )
    end
  end
end
