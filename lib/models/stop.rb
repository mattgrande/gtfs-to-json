class Stop
  include DataMapper::Resource
  attr_accessor :distance

  property :stop_id, String, :key => true
  property :lat, Float
  property :lon, Float
  property :stop_code, String
  property :stop_desc, String
  property :stop_name, String

  # Function stolen from datamapper/dm-serializer
  def as_json(options = { })
  	options = {} if options.nil?
    result  = {}

    # Include distance if there's a value
    if distance > 0
      options[:methods] = [ :distance ]
    end

    properties_to_serialize(options).each do |property|
      property_name = property.name
      value = __send__(property_name)
      result[property_name] = value.kind_of?(DataMapper::Model) ? value.name : value
    end

    # add methods
    Array(options[:methods]).each do |method|
      next unless respond_to?(method)
      result[method] = __send__(method)
    end

    result
  end
end