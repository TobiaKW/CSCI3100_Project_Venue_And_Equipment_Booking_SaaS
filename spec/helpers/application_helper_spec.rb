require 'rails_helper'
require 'webmock/rspec'

RSpec.describe ApplicationHelper, type: :helper do
  let(:api_key) { "test_google_key" }
  let(:building_map) { { "ICC" => "International Commerce Centre" } }
  
  # Mock the API Key and the Building Map before each test
  before do
    stub_const('ENV', ENV.to_h.merge("GOOGLE_MAPS_API_KEY" => api_key))
    allow(helper).to receive(:building_names_map).and_return(building_map)
  end

  describe "#resource_map_query" do
    let(:lat) { 22.3033 }
    let(:lng) { 114.1601 }
    let(:resource) { Resource.new(name: "ICC Room 101", latitude: lat, longitude: lng) }

    context "when geocoding matches the resource coordinates" do
      it "returns the full address string" do
        # Stub the Google API call
        stub_request(:get, /maps.googleapis.com/)
          .with(query: hash_including(address: "International Commerce Centre, Hong Kong"))
          .to_return(status: 200, body: {
            status: "OK",
            results: [{ geometry: { location: { lat: lat, lng: lng } } }]
          }.to_json)

        expect(helper.resource_map_query(resource)).to eq("International Commerce Centre, Hong Kong")
      end
    end

    context "when geocoding coordinates do not match" do
      it "falls back to the coordinate string" do
        # Stub the primary address
        stub_request(:get, /maps.googleapis.com/)
          .with(query: hash_including(address: "International Commerce Centre, Hong Kong"))
          .to_return(status: 200, body: {
            status: "OK",
            results: [{ geometry: { location: { lat: 0, lng: 0 } } }] # No match
          }.to_json)

        # Stub the fallback address (the loop continues)
        stub_request(:get, /maps.googleapis.com/)
          .with(query: hash_including(address: "International Commerce Centre"))
          .to_return(status: 200, body: {
            status: "OK",
            results: [{ geometry: { location: { lat: 0, lng: 0 } } }] # Still no match
          }.to_json)

        expect(helper.resource_map_query(resource)).to eq("#{lat},#{lng}")
      end
    end

    context "when the resource has no location data" do
      it "returns nil" do
        resource.latitude = nil
        resource.longitude = nil
        expect(helper.resource_map_query(resource)).to be_nil
      end
    end
  end

  describe "#coordinates_match?" do
    it "returns true if coordinates are within $0.0001$ degrees" do
      # 22.3033 vs 22.30330001
      expect(helper.send(:coordinates_match?, [22.3033, 114.1601], 22.30330001, 114.1601)).to be true
    end

    it "returns false if coordinates are too far apart" do
      expect(helper.send(:coordinates_match?, [22.3033, 114.1601], 22.4, 114.2)).to be false
    end
  end
end