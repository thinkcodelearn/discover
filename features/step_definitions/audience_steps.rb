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
  topics = table.raw.map do |row|
    Topic.new(row.first)
  end
  @audience = Discover::Audience.new(audience_name, topics)
end
