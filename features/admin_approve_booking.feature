Feature: Admin wants to approve booking
  CUHK starts to use our app and admin want to approve booking

  Scenario: Admin approves a booking with overlapping pending request
    Given there is a booking by "alice" on the resource "SHB 924" with start time "2026-04-20 14:00" and end time "2026-04-20 16:00"
    And there is a booking by "bob" on the resource "SHB 924" with start time "2026-04-20 14:30" and end time "2026-04-20 16:30"

    And I have login with username "admin" and email "admin@example.com"
    Then I should see "Admin Dashboard"
    
    Given I visit the admin dashboard
    Then I should see "Pending Bookings"
    And there are 2 pending bookings listed in total

    Given I approves the first booking
    Then there are 0 pending bookings listed in total

  Scenario: Admin rejects a booking with overlapping pending request
    Given there is a booking by "alice" on the resource "SHB 924" with start time "2026-04-20 14:00" and end time "2026-04-20 16:00"
    And there is a booking by "bob" on the resource "SHB 924" with start time "2026-04-20 14:30" and end time "2026-04-20 16:30"

    And I have login with username "admin" and email "admin@example.com"
    Then I should see "Admin Dashboard"
    
    Given I visit the admin dashboard
    Then I should see "Pending Bookings"
    And there are 2 pending bookings listed in total

    Given I rejects the first booking
    Then there are 1 pending bookings listed in total