Topic = Struct.new :name

Given(/^the site has the following audiences:$/) do |table|
  Discover::AudienceRepository.new.apply(table.raw.map { |row| Discover::Changes::AudienceCreated.new(row.first) })
end

Then(/^I see the list of audiences clearly displayed for me to select from$/) do
  Discover::AudienceRepository.new.active.each do |audience|
    page.should have_css(".audience", text: audience.description)
  end
end

Given(/^an audience "(.*?)" with these associated topics:$/) do |audience_name, table|
  pending
  topic_changes = table.raw.map do |row|
    Discover::Changes::TopicCreated.new(row.first)
  end
  Discover::AudienceRepository.new.apply([ Discover::Changes::AudienceCreated.new(audience_name) ] + topic_changes)
end
