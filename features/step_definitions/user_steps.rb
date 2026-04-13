Given /^I have signed up with username "([^"]*)" and email "([^"]*)"$/ do |username, email|
  visit(new_user_registration_path)
  fill_in('Name', with: username)
  fill_in('Email', with: email)
  select('Engineering', from: 'Department')
  fill_in('Password At Least 6 Characters Long', with: '123456')
  fill_in('Confirm Password', with: '123456')
  click_button('Sign Up')
end

Given /^I have account with username "([^"]*)" and email "([^"]*)"$/ do |username, email|
  User.create!({ name: username, email: email, department: Department.find_by(name: 'Engineering'), password: '123456' })
end

Given /^I have login with username "([^"]*)" and email "([^"]*)"$/ do |username, email|
  visit(new_user_session_path)
  fill_in('Email', with: email)
  fill_in('Password', with: '123456')
  click_button('Log In')
end

Given /^I have logout$/ do
  click_button('Log Out')
end

Given /^I visit the admin dashboard$/ do
  visit(admin_bookings_path)
end

Then /^I should see "([^"]*)"$/ do |desc|
 expect(page).to have_content desc
end
