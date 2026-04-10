require 'rails_helper'
require_relative '../shared_context.rb'
require 'devise'

RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request # to sign_in user by Devise
end

RSpec.describe "Admin authorisation", type: :request do
  include_context :database
  it "user cannot access admin pages" do
    sign_in users[:alice]
    get admin_bookings_path
    expect(response.body).to eq("")
    follow_redirect!
    expect(response.body).to include("Not authorized")
  end

  it "admin cannot see bookings of other department" do
    bookings
    sign_in users[:admin2]
    get admin_bookings_path
    expect(response.body).to include(resources[:lsbc1].name)
    expect(response.body).not_to include(resources[:shb924].name)
  end
end
