Feature: Search for resource
  As a CUHK student
  I want to find good resources

  Scenario: Search resources by keyword
    Given I have account with username "abc" and email "abc@example.com"
    Given I have login with username "abc" and email "abc@example.com"
    Given there are searchable test resources
    When I go to the resource search page
    And I search resources by keyword "TEST Room"
    Then I should see resource "TEST Room Alpha"
    And I should see resource "TEST Room Gamma"
    And I should not see resource "TEST Equipment Beta"

  Scenario: Filter resources by department
    Given I have account with username "abc" and email "abc@example.com"
    Given I have login with username "abc" and email "abc@example.com"
    Given there are searchable test resources
    When I go to the resource search page
    And I filter resources by department "Engineering"
    Then I should see resource "TEST Room Alpha"
    And I should not see resource "TEST Equipment Beta"
    And I should not see resource "TEST Room Gamma"

  Scenario: Filter resources by type
    Given I have account with username "abc" and email "abc@example.com"
    Given I have login with username "abc" and email "abc@example.com"
    Given there are searchable test resources
    When I go to the resource search page
    And I filter resources by type "room"
    Then I should see resource "TEST Room Alpha"
    And I should see resource "TEST Room Gamma"
    And I should not see resource "TEST Equipment Beta"