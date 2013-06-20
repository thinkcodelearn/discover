Then(/^I should see the topics I'm interested in$/) do
  @topics.each do |topic|
    page.should have_css(".topic", text: topic.name)
  end
end


Given(/^an example topic "(.*?)" within "(.*?)" with this example place:$/) do |topic, audience, table|
  @places = table.transpose.hashes.map do |row|
    lat, lng = row['Location'].split(', ')
    Discover::Place.new(
      row['Name'],
      row['Information'],
      lat,
      lng,
      row['Address'],
      row['Telephone'],
      row['URL'],
      row['E-mail'],
      row['Facebook'],
      row['Twitter'])
  end
  @topic = Discover::Topic.new(topic)
  @audience = Discover::Audience.new(audience, nil, [@topic.slug])

  changes = []
  changes << Discover::Changes::TopicCreated.new(@topic)
  changes << Discover::Changes::AudienceCreated.new(@audience)

  place_changes = @places.map { |p| Discover::Changes::PlaceAddedToTopic.new(@topic, p) }
  Discover::AudienceRepository.new.apply(changes + place_changes)
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

When(/^I (?:try to )?create a(?:nother)? topic "(.*?)"$/) do |topic_name|
  @topic_name = topic_name
  basic_auth('discover', '')
  visit '/admin'
  click_link 'Create topic'
  fill_in 'Topic name', :with => topic_name
  click_button 'Create topic'
  should_be_success
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
  page.should have_css(".topic", text: @topic_name)
end
