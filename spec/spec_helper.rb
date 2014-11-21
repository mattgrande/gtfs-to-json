require "simplecov"
SimpleCov.start

ENV['RACK_ENV'] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

RSpec.configure do |conf|
  conf.include Rack::Test::Methods

  conf.before(:each) do
    DataMapper::Model.descendants.each { |m| m.all.destroy }
  end
end
