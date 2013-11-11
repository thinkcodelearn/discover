Then(/^I should see the topics I'm interested in$/) do
  @topics.each do |topic|
    page.should have_css(".topic", text: topic.name)
  end
end

Given(/^an example topic "(.*?)" within "(.*?)" with this example place:$/) do |topic, audience, table|
  @places = places_from(table)
  @topic = Discover::Topic.new(topic, "", nil, @places.map(&:slug))
  @audience = Discover::Audience.new(audience, nil, [@topic.slug])

  changes = []
  @places.each do |place|
    changes << Discover::Changes::PlaceCreated.new(place)
  end
  changes << Discover::Changes::TopicCreated.new(@topic)
  changes << Discover::Changes::AudienceCreated.new(@audience)

  Discover::AudienceRepository.new.apply(changes)
end

When(/^I view the "(.*?)" topic within "(.*?)"$/) do |topic, audience|
  visit '/' + Discover::Audience.new(audience).slug + '/' + Discover::Topic.new(topic).slug
end

Then(/^I can see a map showing the place above$/) do
  page.should have_css("#map")
end

Then(/^I can see basic information about the place$/) do
  @places.each do |place|
    page.should have_css(".place .name", text: place.name)
    page.should have_css(".place .address", text: place.address)
  end
end

When(/^I create a topic "(.*?)" with description "(.*?)"$/) do |topic_name, description|
  create_topic(topic_name, description)
end

When(/^I (?:try to )?create a(?:nother)? topic "([^"]+)"$/) do |topic_name|
  create_topic(topic_name)
end

When(/^I associate it with the "(.*?)" audience$/) do |audience_name|
  @audience_name = audience_name
  visit '/admin'
  click_link audience_name
  select @topic_name
  click_button 'Save changes'
  should_be_success
end


Then(/^the topic should be shown under that audience$/) do
  visit '/'
  click_link @audience_name
  should_have_topic @topic_name
  should_have_topic_description @description if !@description.empty?
end

Then(/^I see an error telling me I can't create two topics with the same name$/) do
  page.should have_css(".alert-error")
end


When(/^I change the name of the topic "(.*?)" to "(.*?)"$/) do |old_name, new_name|
  @new_name = new_name
  basic_auth('discover', '')
  visit '/admin'
  click_link old_name
  fill_in 'Topic name', :with => new_name
  click_button 'Save changes'
  should_be_success
end

Then(/^the topic name should be updated on the main site$/) do
  visit '/'
  click_link @audience_name
  should_have_topic @new_name
end

When(/^I delete the topic again$/) do
  basic_auth('discover', '')
  visit '/admin'
  click_link @topic_name
  click_button 'Delete'
  should_be_success
end

Then(/^the topic is no longer shown on the admin site$/) do
  visit '/admin'
  expect(page).not_to have_css('.topic', text: @topic_name)
end
