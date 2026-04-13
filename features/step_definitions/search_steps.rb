When('I go to the resource search page') do
  visit(root_path)
end

When('I search resources by keyword {string}') do |keyword|
  fill_in('Enter resource name...', with: keyword)
  click_button('Search')
end

When('I filter resources by department {string}') do |department_name|
  select department_name, from: 'department_id'
  click_button('Search')
end

When('I filter resources by type {string}') do |resource_type|
  select resource_type.titleize, from: 'rtype'
  click_button('Search')
end

Then('I should see resource {string}') do |resource_name|
  expect(page).to have_content(resource_name)
end

Then('I should not see resource {string}') do |resource_name|
  expect(page).not_to have_content(resource_name)
end

Then('I should see {int} resources in the search result') do |count|
  expect(page).to have_css('.resources-grid .resource-card', count: count)
end