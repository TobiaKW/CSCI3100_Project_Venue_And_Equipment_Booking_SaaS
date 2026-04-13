Feature: Resource Map Query
  As a user
  I want to see the best possible address or coordinate for a resource
  So that I can locate it on a map accurately

  Background:
    Given the building "ICC" is mapped to "International Commerce Centre"

  Scenario: Resource name matches geocoded building location
    Given a resource named "ICC Room 101" exists at latitude 22.3033 and longitude 114.1601
    And the Google Geocoding API returns 22.3033, 114.1601 for "International Commerce Centre, Hong Kong"
    Then the map query for this resource should be "International Commerce Centre, Hong Kong"

  Scenario: Resource coordinates exist but do not match building geocode
    Given a resource named "ICC Room 101" exists at latitude 22.5000 and longitude 114.5000
    And the Google Geocoding API returns 22.3033, 114.1601 for "International Commerce Centre, Hong Kong"
    And the Google Geocoding API returns 22.3033, 114.1601 for "International Commerce Centre"
    Then the map query for this resource should be "22.5,114.5"

  Scenario: Resource has no location data
    Given a resource named "Unknown Place" exists without coordinates
    Then the map query for this resource should be empty