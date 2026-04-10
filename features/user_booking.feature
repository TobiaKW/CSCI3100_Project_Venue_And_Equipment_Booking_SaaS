Feature: User wants to book a room
  Everyone likes our app and wants to book room

  Scenario: User books a room successfully
    Given I have login with username "alice" and email "alice@example.com"
    Given I book the resource "SHB 924" with start time "2026-04-20 12:00" and end time "2026-04-20 14:00"
    Then I should see "Booking requested."

  Scenario: User books a room unsuccessfully due to start time after end time
    Given I have login with username "alice" and email "alice@example.com"
    Given I book the resource "SHB 924" with start time "2026-04-20 14:00" and end time "2026-04-20 12:00"
    Then I should see "End time must be after start time"

  Scenario: User books a room unsuccessfully due to duration less than an hour
    Given I have login with username "alice" and email "alice@example.com"
    Given I book the resource "SHB 924" with start time "2026-04-20 14:00" and end time "2026-04-20 14:30"
    Then I should see "Booking must last at least one hour"
    
  Scenario: User books a room unsuccessfully due to less than 7 days in advance
    Given I have login with username "alice" and email "alice@example.com"
    Given I book the resource "SHB 924" with start time "2026-04-19 14:00" and end time "2026-04-19 15:00"
    Then I should see "Booking must be made at least 7 days in advance"

  Scenario: User books a room unsuccessfully due to overlapping
    Given I have login with username "alice" and email "alice@example.com"
    Given I book the resource "SHB 924" with start time "2026-04-20 14:00" and end time "2026-04-20 15:00"
    Then I should see "Booking requested."
    Given admin approves the booking on the resource "SHB 924" with start time "2026-04-20 14:00" and end time "2026-04-20 15:00"
    And I book the resource "SHB 924" with start time "2026-04-20 14:00" and end time "2026-04-20 15:00"
    Then I should see "This time overlaps another booking for this resource"

  Scenario: User books a room unsuccessfully due to overnight
    Given I have login with username "alice" and email "alice@example.com"
    Given I book the resource "SHB 924" with start time "2026-04-20 14:00" and end time "2026-04-21 00:30"
    Then I should see "You cannot book a venue for overnight"