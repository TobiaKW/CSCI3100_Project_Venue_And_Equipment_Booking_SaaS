Given /^I book the resource "([^"]*)" with start time "([^"]*)" and end time "([^"]*)"$/ do |resource_name, start_time, end_time|
  resource_id = Resource.find_by({name: resource_name}).id
  visit(new_booking_path(params: {'resource_id': resource_id}))
  fill_in 'Start Time', with: start_time
  fill_in 'End Time', with: end_time
  click_button 'Confirm Booking'
end

Given /^there is a booking by "([^"]*)" on the resource "([^"]*)" with start time "([^"]*)" and end time "([^"]*)"$/ do |username, resource_name, start_time, end_time|
  user = User.find_by({name: username})
  resource = Resource.find_by({name: resource_name})
  Booking.create!( { user: user, resource: resource, start_time: start_time, end_time: end_time })
end

Given /^admin approves the booking on the resource "([^"]*)" with start time "([^"]*)" and end time "([^"]*)"$/ do |resource_name, start_time, end_time|
  resource_id = Resource.find_by({name: resource_name}).id
  booking = Booking.find_by({'resource_id': resource_id, 'start_time': start_time, 'end_time': end_time})
  booking.update({status: 'approved'})
end

Then('there are {int} pending bookings listed in total') do |pending_count|
  if pending_count == 0
    expect(page).to have_content 'No pending bookings'
  else
    expect(page.find('.bookings-table > tbody')).to have_selector('tr', count: pending_count)
  end
end

Given /^I ([a-zA-Z]+) the first booking$/ do |decision|
  if decision == "approves"
    pp(page.first('.bookings-table > tbody > tr'))
    page.first('.bookings-table > tbody > tr').find('a', :text => 'Approve').click
  else
    pp(page.first('.bookings-table > tbody > tr'))
    page.first('.bookings-table > tbody > tr').find('a', :text => 'Reject').click
  end
end