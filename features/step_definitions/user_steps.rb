Given /^I have signed up with username "([^"]*)" and email "([^"]*)"$/ do |username, email|
  visit(new_user_registration_path)
  fill_in('Name', :with => username)
  fill_in('Email', :with => email)
  select('Engineering', :from => 'Department')
  fill_in('Password', :with => '123456')
  fill_in('Password confirmation', :with => '123456')
  click_button('Sign up')
end

Given /^I have account with username "([^"]*)" and email "([^"]*)"$/ do |username, email|
  User.create!({name: username, email: email, department: Department.find_by(name: 'Engineering'), password: '123456'})
end

Given /^I have login with username "([^"]*)" and email "([^"]*)"$/ do |username, email|
  visit(new_user_session_path)
  fill_in('Email', :with => email)
  fill_in('Password', :with => '123456')
  click_button('Log in')
end

Given /^I have logout$/ do
  click_button('Log out')
end

Then /^I should see "([^"]*)"$/ do |desc|
 expect(page).to have_content desc
end