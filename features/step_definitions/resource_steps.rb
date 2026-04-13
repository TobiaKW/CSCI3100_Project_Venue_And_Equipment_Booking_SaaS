# features/step_definitions/resource_steps.rb
require 'webmock/cucumber'

# Set up a clean instance of the helper before each scenario
Before do
  @helper = Object.new
  @helper.extend(ApplicationHelper)
  
  # Default stub: Empty building map to avoid reading from the real YAML file
  allow(@helper).to receive(:building_names_map).and_return({})
end

Given('the building {string} is mapped to {string}') do |code, full_name|
  # Override the default stub for the current scenario
  allow(@helper).to receive(:building_names_map).and_return({
    code => full_name
  })
end

Given('a resource named {string} exists at latitude {float} and longitude {float}') do |name, lat, lng|
  # Using .new instead of .create! to keep tests fast by avoiding the database
  @resource = Resource.new(name: name, latitude: lat, longitude: lng)
end

Given('a resource named {string} exists without coordinates') do |name|
  @resource = Resource.new(name: name, latitude: nil, longitude: nil)
end

Given('the Google Geocoding API returns {float}, {float} for {string}') do |lat, lng, address|
  api_key = ENV["GOOGLE_MAPS_API_KEY"] || "test_key"
  
  stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json")
    .with(query: { address: address, key: api_key })
    .to_return(status: 200, body: {
      status: "OK",
      results: [{
        geometry: { 
          location: { lat: lat, lng: lng } 
        }
      }]
    }.to_json)
end

Then('the map query for this resource should be {string}') do |expected_query|
  # We call the method on our isolated @helper object
  actual_query = @helper.resource_map_query(@resource)
  expect(actual_query).to eq(expected_query)
end

Then('the map query for this resource should be empty') do
  actual_query = @helper.resource_map_query(@resource)
  expect(actual_query).to be_nil
end