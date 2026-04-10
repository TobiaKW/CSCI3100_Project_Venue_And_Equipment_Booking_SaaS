Given /^I book the resource "([^"]*)" with start time "([^"]*)" and end time "([^"]*)"$/ do |resource_name, start_time, end_time|
  resource_id = Resource.find_by({name: resource_name}).id
  visit(new_booking_path(params: {'resource_id': resource_id}))
  fill_in 'Start Time', with: start_time
  fill_in 'End Time', with: end_time
  click_button 'Confirm Booking'
end