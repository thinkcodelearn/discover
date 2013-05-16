module Discover
  Topic = Struct.new :name
end

Given(/^the site has the following audiences:$/) do |table|
  @audiences = table.raw.map { |row| Discover::Audience.new(row.first) }
  Discover::AudienceRepository.new.apply(@audiences.map {|a| Discover::Changes::AudienceCreated.new(a) })
end

Then(/^I see the list of audiences clearly displayed for me to select from$/) do
  Discover::AudienceRepository.new.active.each do |audience|
    page.should have_css(".audience", text: audience.description)
  end
end

Given(/^an audience "(.*?)" with these associated topics:$/) do |description, table|
  @topics = table.raw.map { |row| Discover::Topic.new(row.first) }
  audience_creation = Discover::Changes::AudienceCreated.new(Discover::Audience.new(description))
  topic_changes = @topics.map { |t| Discover::Changes::TopicCreated.new(t) }

  Discover::AudienceRepository.new.apply([ audience_creation ] + topic_changes)
end
