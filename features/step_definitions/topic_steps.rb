Then(/^I should see the topics I'm interested in$/) do
  @topics.each do |topic|
    page.should have_css(".topic", text: topic.name)
  end
end


Given(/^an example topic "(.*?)" within "(.*?)" with these example places:$/) do |topic, audience, table|
  @places = table.hashes.map do |row|
    lat, lng = row['Location'].split(', ')
    Discover::Place.new(row['Name'], row['Information'], lat, lng)
  end
  @topic = Discover::Topic.new(topic)
  @audience = Discover::Audience.new(audience)

  changes = []
  changes << Discover::Changes::AudienceCreated.new(@audience)
  changes << Discover::Changes::TopicCreated.new(@topic)
  changes << Discover::Changes::TopicAttachedToAudience.new(@audience, @topic)

  place_changes = @places.map { |p| Discover::Changes::PlaceAddedToTopic.new(@topic, p) }
  Discover::AudienceRepository.new.apply(changes + place_changes)
end

When(/^I view the "(.*?)" topic within "(.*?)"$/) do |topic, audience|
  visit '/' + Discover::Audience.new(audience).slug + '/' + Discover::Topic.new(topic).slug
end

Then(/^I can see a map showing all the different places above$/) do
  page.should have_css("#map")
end

Then(/^I can see basic information about each place$/) do
  @places.each do |place|
    page.should have_css(".place", text: place.name)
  end
end
