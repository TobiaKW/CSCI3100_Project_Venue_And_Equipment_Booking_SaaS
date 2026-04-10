Feature: User want to register and login to account
  Everyone likes our app and wants to try

  Scenario: User register an account successfully
    Given I have signed up with username "abc" and email "abc@example.com"
    Then I should see "Welcome! You have signed up successfully."

  Scenario: User register an account with same email
    Given I have account with username "abc" and email "abc@example.com"
    Given I have signed up with username "abcd" and email "abc@example.com"
    Then I should see "error"

  Scenario: User register an account with same username
    Given I have account with username "abc" and email "abc@example.com"
    Given I have signed up with username "abc" and email "abcd@example.com"
    Then I should see "error"

  Scenario: User login to an account
    Given I have account with username "abc" and email "abc@example.com"
    Given I have login with username "abc" and email "abc@example.com"
    Then I should see "Signed in successfully."

  Scenario: User fails login to an account
    Given I have account with username "abc" and email "abc@example.com"
    Given I have login with username "abcd" and email "abcd@example.com"
    Then I should see "Invalid email or password."

  Scenario: User logouts account and redirects to login page
    Given I have account with username "abc" and email "abc@example.com"
    Given I have login with username "abc" and email "abc@example.com"
    Given I have logout
    Then I should see "Log in"