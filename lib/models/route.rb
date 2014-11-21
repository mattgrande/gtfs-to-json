class Route
  include DataMapper::Resource

  has n, :buses, 'Bus', :child_key => [ :route_id ]

  property :route_id, String, :key => true
  property :created_at, DateTime
  property :route_number, String  # eg, 05
  property :route_name, String    # eg, 05 DELAWARE
  property :text_color, String    # HTML colour used for branding, eg, FFFFFF
  property :bg_color, String      # HTML colour used for branding, eg, FFFFFF
end