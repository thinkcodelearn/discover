Then(/^I should see the topics I'm interested in$/) do
  @topics.each do |topic|
    page.should have_css(".topic", text: topic.name)
  end
end


Given(/^an example topic "(.*?)" with these example places:$/) do |topic, table|
  @places = table.hashes.map do |row|
    lat, lng = row['Location'].split(', ')
    Discover::Place.new(row['Name'], row['Information'], lat, lng)
  end
  @topic = Discover::Topic.new(topic)

  topic_change = Discover::Changes::TopicCreated.new(@topic)
  place_changes = @places.map { |p| Discover::Changes::PlaceAddedToTopic.new(@topic, p) }
  Discover::AudienceRepository.new.apply([ topic_change ] + place_changes)
end

When(/^I view the "(.*?)" topic$/) do |topic|
  visit '/' + Discover::Topic.new(topic).slug
end

Then(/^I can see a map showing all the different places above$/) do
  page.should have_css(".map")
end
