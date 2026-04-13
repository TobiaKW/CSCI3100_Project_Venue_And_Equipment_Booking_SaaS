require 'webmock/cucumber'

# Set up a clean instance of the helper before each scenario
Before do
  # Ensure an API key exists so the helper's blank? check doesn't trigger
  ENV["GOOGLE_MAPS_API_KEY"] ||= "test_key"
  
  @helper = Object.new
  @helper.extend(ApplicationHelper)
  
  # Default stub: Empty building map
  allow(@helper).to receive(:building_names_map).and_return({})
end

Given('the building {string} is mapped to {string}') do |code, full_name|
  # Your helper uses acc[key.to_s.upcase], so we must upcase the key here
  allow(@helper).to receive(:building_names_map).and_return({
    code.upcase => full_name
  })
end

Given('a resource named {string} exists at latitude {float} and longitude {float}') do |name, lat, lng|
  @resource = Resource.new(name: name, latitude: lat, longitude: lng)
end

Given('a resource named {string} exists without coordinates') do |name|
  @resource = Resource.new(name: name, latitude: nil, longitude: nil)
end

Given('the Google Geocoding API returns {float}, {float} for {string}') do |lat, lng, address|
  api_key = ENV["GOOGLE_MAPS_API_KEY"]
  
  # Using hash_including is much more robust for URL parameters
  stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json")
    .with(query: hash_including({ "address" => address, "key" => api_key }))
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
  actual_query = @helper.resource_map_query(@resource)
  
  # Helpful debug print if the test fails again
  if actual_query != expected_query
    puts "\nDEBUG: Expected '#{expected_query}', but got '#{actual_query}'"
  end

  expect(actual_query).to eq(expected_query)
end

Then('the map query for this resource should be empty') do
  actual_query = @helper.resource_map_query(@resource)
  expect(actual_query).to be_nil
end