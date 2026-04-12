require "json"
require "net/http"
require "uri"
require "yaml"

namespace :resource_locations do
  def load_building_names
    path = Rails.root.join("config/building_names.yml")
    return {} unless File.exist?(path)

    raw = YAML.safe_load_file(path) || {}
    raw.each_with_object({}) do |(code, building_name), acc|
      name = building_name.to_s.strip
      next if name.empty?

      acc[code.to_s.upcase] = name
    end
  rescue Psych::SyntaxError
    {}
  end

  def geocode_coordinates(address, api_key)
    # Query Google Geocoding API and return [lat, lng] or nil when unresolved.
    uri = URI("https://maps.googleapis.com/maps/api/geocode/json")
    uri.query = URI.encode_www_form(address: address, key: api_key)

    response = Net::HTTP.get_response(uri)
    return nil unless response.is_a?(Net::HTTPSuccess)

    payload = JSON.parse(response.body)
    return nil unless payload["status"] == "OK" && payload["results"].any?

    location = payload["results"].first.dig("geometry", "location")
    return nil unless location

    [location["lat"], location["lng"]]
  rescue JSON::ParserError, StandardError
    nil
  end

  def candidate_addresses_for(resource, building_names)
    code = resource.name.to_s.split.first.to_s.gsub(/[^A-Za-z]/, "").upcase
    exact_building_name = building_names[code]
    return [] if exact_building_name.blank?

    [
      "#{exact_building_name}, Hong Kong",
      exact_building_name
    ].compact.uniq
  end

  desc "Populate resource coordinates using Google Geocoding API by exact building name"
  task populate_from_geocoding: :environment do
    api_key = ENV["GOOGLE_MAPS_API_KEY"].to_s.strip
    if api_key.empty?
      abort "GOOGLE_MAPS_API_KEY is missing. Add it to .env and restart your terminal/server."
    end
    building_names = load_building_names
    if building_names.empty?
      abort "No building names found. Create config/building_names.yml from config/building_names.example.yml first."
    end

    updated = 0
    skipped_has_coords = 0
    skipped_no_location = 0
    failed = 0
    cache = {}

    Resource.includes(:department).find_each do |resource|
      if resource.latitude.present? && resource.longitude.present?
        skipped_has_coords += 1
        next
      end

      # Check if this resource has a valid building code
      addresses = candidate_addresses_for(resource, building_names)
      if addresses.empty?
        # This resource has no location (e.g., badminton bat, equipment without a room)
        skipped_no_location += 1
        next
      end

      coordinates = nil
      addresses.each do |address|
        # Cache geocoding results to reduce duplicate API calls.
        coordinates = cache[address]
        if coordinates.nil? && !cache.key?(address)
          coordinates = geocode_coordinates(address, api_key)
          cache[address] = coordinates
        end
        break if coordinates
      end

      if coordinates
        if resource.update(latitude: coordinates[0], longitude: coordinates[1])
          updated += 1
        else
          failed += 1
          puts "Failed to update Resource##{resource.id} (#{resource.name}): #{resource.errors.full_messages.join(', ')}"
        end
      else
        failed += 1
        puts "No coordinates found for Resource##{resource.id} (#{resource.name})"
      end
    end

    puts "Updated: #{updated} resources"
    puts "Skipped (already has coordinates): #{skipped_has_coords} resources"
    puts "Skipped (no location): #{skipped_no_location} resources"
    puts "Failed: #{failed} resources"
  end
end
