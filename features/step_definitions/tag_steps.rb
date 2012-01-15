When /^I create a tag$/ do
  click_button("Create tag")
  @tag = /Tag created: ([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})/.match(page.body)[1]
end

When /^I check the tag status$/ do
  visit "/#{@tag}"
end

When /^I start the repository creator$/ do
  `bundle exec ruby #{CREATOR_CONTROL_FILE} start`
end

Given /^I stop the repository creator$/ do
  `bundle exec ruby #{CREATOR_CONTROL_FILE} stop`
end


When /^I have a cup of tea$/ do
  #TODO : stop mucking about
  sleep 10
end