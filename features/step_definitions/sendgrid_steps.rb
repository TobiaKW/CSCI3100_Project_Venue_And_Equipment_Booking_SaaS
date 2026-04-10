require 'webmock/cucumber'

Given('I have configured the SendGrid HTTP delivery method') do
  @delivery_method = SendgridHttpDelivery.new(api_key: 'test_key_123')
end

Given('the SendGrid API is healthy') do
  stub_request(:post, "https://api.sendgrid.com/v3/mail/send")
    .to_return(status: 202, body: "", headers: {})
end

When('I deliver a test email with:') do |table|
  details = table.rows_hash

  mail = Mail.new do
    from    'admin@system.com'
    to      details['to']
    subject details['subject']
    body    details['body']
  end

  @delivery_method.deliver!(mail)
end

Then('a POST request should have been made to {string}') do |url|
  assert_requested(:post, url)
end

And('the JSON payload should contain:') do |table|
  details = table.rows_hash

  assert_requested(:post, "https://api.sendgrid.com/v3/mail/send") do |req|
    body = JSON.parse(req.body)

    subject_match = body['subject'] == details['subject']
    to_match = body['personalizations'][0]['to'].any? { |to| to['email'] == details['email'] }

    subject_match && to_match
  end
end
