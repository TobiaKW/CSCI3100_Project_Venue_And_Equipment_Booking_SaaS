Feature: SendGrid HTTP Delivery
  I want to send email

  Scenario: Successfully sending a email
    Given I have configured the SendGrid HTTP delivery method
    And the SendGrid API is healthy
    When I deliver a test email with:
      | subject | Hello from Cucumber |
      | to      | user@example.com    |
      | body    | This is the body    |
    Then a POST request should have been made to "https://api.sendgrid.com/v3/mail/send"
    And the JSON payload should contain:
      | subject | Hello from Cucumber |
      | email   | user@example.com    |