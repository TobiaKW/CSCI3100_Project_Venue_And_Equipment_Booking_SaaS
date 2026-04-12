def find_user_by_name!(name)
  User.find_by(name: name) || raise("User not found: #{name}")
end

def find_resource_by_name!(name)
  Resource.find_by(name: name) || raise("Resource not found: #{name}")
end

Given /^I book the resource "([^"]*)" with start time "([^"]*)" and end time "([^"]*)"$/ do |resource_name, start_time, end_time|
  resource = find_resource_by_name!(resource_name)
  visit(new_booking_path(resource_id: resource.id))
  fill_in 'Start Time', with: start_time
  fill_in 'End Time', with: end_time
  click_button 'Confirm Booking'
end

Given /^there is a booking by "([^"]*)" on the resource "([^"]*)" with start time "([^"]*)" and end time "([^"]*)"$/ do |username, resource_name, start_time, end_time|
  user = find_user_by_name!(username)
  resource = find_resource_by_name!(resource_name)
  Booking.create!(
    user: user,
    resource: resource,
    start_time: start_time,
    end_time: end_time,
    status: 'pending'
  )
end

Given /^admin approves the booking on the resource "([^"]*)" with start time "([^"]*)" and end time "([^"]*)"$/ do |resource_name, start_time, end_time|
  resource = find_resource_by_name!(resource_name)
  booking = Booking.find_by(resource_id: resource.id, start_time: start_time, end_time: end_time)
  raise("Booking not found for #{resource_name} at #{start_time} - #{end_time}") if booking.nil?

  booking.update!(status: 'approved')
end

Then('there are {int} pending bookings listed in total') do |pending_count|
  if pending_count == 0
    expect(page).to have_content 'No pending bookings'
  else
    expect(page.find('.bookings-table > tbody')).to have_selector('tr', count: pending_count)
  end
end

Given('I {word} the first booking') do |decision|
  row = page.first('.bookings-table > tbody > tr')
  raise 'No booking row found in admin dashboard' if row.nil?

  case decision
  when 'approves'
    row.find('a', text: 'Approve').click
  when 'rejects'
    row.find('a', text: 'Reject').click
  else
    raise ArgumentError, "Unsupported decision: #{decision}. Use 'approves' or 'rejects'."
  end
end

Given('there are searchable test resources') do
  engineering = Department.find_or_create_by!(name: 'Engineering')
  medicine = Department.find_or_create_by!(name: 'Medicine')

  Resource.find_or_create_by!(name: 'TEST Room Alpha', department: engineering) do |resource|
    resource.rtype = 'room'
    resource.capacity = 40
    resource.seat_type = 'Table & Chair'
  end

  Resource.find_or_create_by!(name: 'TEST Equipment Beta', department: engineering) do |resource|
    resource.rtype = 'equipment'
    resource.capacity = -1
    resource.seat_type = 'N/A'
  end

  Resource.find_or_create_by!(name: 'TEST Room Gamma', department: medicine) do |resource|
    resource.rtype = 'room'
    resource.capacity = 30
    resource.seat_type = 'Armchair'
  end
end
