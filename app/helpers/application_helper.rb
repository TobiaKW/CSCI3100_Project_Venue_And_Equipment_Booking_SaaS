require "json"
require "net/http"
require "uri"

module ApplicationHelper
	def resource_map_query(resource)
		candidate = matched_name_query(resource)
		return candidate if candidate.present?

		if resource.has_location?
			"#{resource.latitude},#{resource.longitude}"
		end
	end

	def resource_location_queries(resource)
		code = resource.name.to_s.split.first.to_s.gsub(/[^A-Za-z]/, "").upcase
		building_name = building_names_map[code]
		return [] if building_name.blank?

		[
			"#{building_name}, Hong Kong",
			building_name
		]
	end

	private

	def matched_name_query(resource)
		return nil unless resource.has_location?

		resource_location_queries(resource).each do |address|
			geocoded_coordinates = geocode_coordinates(address)
			next unless coordinates_match?(geocoded_coordinates, resource.latitude, resource.longitude)

			return address
		end

		nil
	end

	def geocode_coordinates(address)
		api_key = ENV["GOOGLE_MAPS_API_KEY"].to_s.strip
		return nil if api_key.blank?

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

	def coordinates_match?(geocoded_coordinates, latitude, longitude)
		return false if geocoded_coordinates.blank?

		saved_lat = Float(latitude)
		saved_lng = Float(longitude)
		query_lat = Float(geocoded_coordinates[0])
		query_lng = Float(geocoded_coordinates[1])

		(saved_lat - query_lat).abs < 0.0001 && (saved_lng - query_lng).abs < 0.0001
	rescue ArgumentError, TypeError
		false
	end

	def building_names_map
		@building_names_map ||= begin
			path = Rails.root.join("config/building_names.yml")

			if File.exist?(path)
				raw = YAML.safe_load_file(path) || {}
				raw.each_with_object({}) do |(key, value), acc|
					name = value.to_s.strip
					next if name.empty?

					acc[key.to_s.upcase] = name
				end
			else
				{}
			end
		rescue Psych::SyntaxError
			{}
		end
	end
end
