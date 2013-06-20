When(/^I create an example place within the topic "(.*?)":$/) do |topic, table|
  repo = Discover::AudienceRepository.new

  basic_auth('discover', '')
  visit '/admin'
  click_link 'Create place'

  table.raw.each do |field, value|
    @place_name = value if field == "Name"
    if field == "Location"
      lat, lng = value.split(", ")
      fill_in 'lat', :with => lat
      fill_in 'lng', :with => lng
    else
      fill_in field, :with => value
    end
  end

  click_button "Create place"
  @places = Discover::AudienceRepository.new.places

  click_link topic
  select @place_name
  click_button "Save changes"
end

Given(/^I have created a place called "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

When(/^I change the name of the place to "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^the place name should be updated on the main site$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I delete the place again$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the place is no longer shown on the admin site$/) do
  pending # express the regexp above with the code you wish you had
end
