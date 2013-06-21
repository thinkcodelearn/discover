When(/^I create an example place within the topic "(.*?)":$/) do |topic, table|
  repo = Discover::AudienceRepository.new

  basic_auth('discover', '')
  visit '/admin'
  click_link 'Create place'

  table.raw.each do |field, value|
    @place_name = value if field == "Name"
    if field == "Location"
      lat, lng = value.split(", ")
      find(:css, '#lat').set lat
      find(:css, '#lng').set lng
    else
      fill_in field, :with => value
    end
  end

  click_button "Create place"
  @places = [Discover::AudienceRepository.new.places.last]

  click_link topic
  select @place_name
  click_button "Save changes"
end

Given(/^I have created a place called "(.*?)"$/) do |place_name|
  @old_name = place_name
  change = Discover::Changes::PlaceCreated.new(Discover::Place.new(place_name))
  Discover::AudienceRepository.new.apply([change])
end

When(/^I change the name of the place to "(.*?)"$/) do |new_name|
  @new_name = new_name
  basic_auth('discover', '')
  visit '/admin'
  click_link @old_name
  fill_in 'Name', :with => new_name
  click_button 'Save changes'
  should_be_success
end

Then(/^the place name should be updated/) do
  basic_auth('discover', '')
  visit '/admin'
  page.should have_content(@new_name)
end

When(/^I delete the place again$/) do
  basic_auth('discover', '')
  visit '/admin'
  click_link @old_name
  click_button 'Delete'
  should_be_success
end

Then(/^the place is no longer shown on the admin site$/) do
  basic_auth('discover', '')
  visit '/admin'
  page.should_not have_content(@old_name)
end
