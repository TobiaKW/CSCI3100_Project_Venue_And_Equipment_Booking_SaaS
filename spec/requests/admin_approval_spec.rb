require 'rails_helper'
require_relative '../shared_context.rb'
require 'devise'

RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request # to sign_in user by Devise
end

RSpec.describe "Admin approval of bookings", type: :request do
  include_context :database
  it "admin approves" do
    bookings # lazy eval

    sign_in users[:admin]
    get admin_bookings_path
    expect(response).to render_template(:application)

    # should have three pending bookings
    assert_select ".bookings-table > tbody > tr" do |bookings|
      expect(bookings.count).to eq(3)
    end

    patch admin_booking_path(bookings[:alice_924].id), params: { status: 'approved' }
    expect(response.status).to eq(302)

    get admin_bookings_path
    # should have one pending booking only due to overlap
    assert_select ".bookings-table > tbody > tr" do |bookings|
      expect(bookings.count).to eq(1)
    end
  end

  it "admin rejects" do
    bookings # lazy eval

    sign_in users[:admin]
    get admin_bookings_path
    expect(response).to render_template(:application)

    # should have three pending bookings
    assert_select ".bookings-table > tbody > tr" do |bookings|
      expect(bookings.count).to eq(3)
    end

    patch admin_booking_path(bookings[:alice_924].id), params: { status: 'rejected' }
    expect(response.status).to eq(302)

    get admin_bookings_path
    # should have two pending bookings only due to overlap
    assert_select ".bookings-table > tbody > tr" do |bookings|
      expect(bookings.count).to eq(2)
    end
  end
end
