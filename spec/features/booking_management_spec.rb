require 'rails_helper'
require_relative '../shared_context.rb'

RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :feature # to sign_in user by Devise
end

RSpec.feature "Booking management", type: :feature do
  include_context :database
  scenario "User make a new booking" do
    resources
    sign_in users[:alice]

    visit new_booking_path(params: { resource_id: resources[:shb924].id })
    expect(page).to have_text('Make a Booking')

    fill_in 'booking_start_time', with: '2026-05-10 14:00:00'
    fill_in 'booking_end_time', with: '2026-05-10 16:00:00'

    find('input[type=submit]').click
    expect(page).to have_text('Booking requested.')

    visit bookings_path
    expect(page).to have_selector('.resource-card', count: 1)
  end

  scenario "User make a new booking wrongly" do
    resources
    sign_in users[:alice]
    visit new_booking_path(params: { resource_id: resources[:shb924].id })
    expect(page).to have_text('Make a Booking')

    fill_in 'booking_start_time', with: '2026-05-10 14:00:00'
    fill_in 'booking_end_time', with: '2026-05-10 12:00:00'

    find('input[type=submit]').click
    expect(page).to have_text('error')

    visit bookings_path
    expect(page).to have_selector('.resource-card', count: 0)
  end
end
