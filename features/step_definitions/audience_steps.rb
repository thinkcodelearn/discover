Given(/^the site has the following example audiences:$/) do |table|
  @audiences = table.raw.map { |row| Discover::Audience.new(row.first) }
  Discover::AudienceRepository.new.apply(@audiences.map {|a| Discover::Changes::AudienceCreated.new(a) })
end

Then(/^I see the list of audiences clearly displayed for me to select from$/) do
  Discover::AudienceRepository.new.active_audiences.each do |audience|
    should_have_audience audience.description
  end
end

Given(/^an example audience "(.*?)" with these associated topics:$/) do |description, table|
  @topics = table.raw.map { |row| Discover::Topic.new(row.first) }
  @audience = Discover::Audience.new(description)

  audience_change = Discover::Changes::AudienceCreated.new(@audience)
  topic_changes =
    @topics.map { |t| Discover::Changes::TopicCreated.new(t) } +
    @topics.map { |t| Discover::Changes::TopicAttachedToAudience.new(@audience, t) }

  Discover::AudienceRepository.new.apply([ audience_change ] + topic_changes)
end


When(/^I (?:try to )?create an(?:other)? audience "(.*?)"$/) do |audience_name|
  @audience_name = audience_name
  basic_auth('discover', '')
  visit '/admin'
  click_link 'Create audience'
  fill_in 'Audience description', :with => audience_name
  click_button 'Create audience'
end

Then(/^the audience should be available for viewing on the main site$/) do
  visit '/'
  should_have_audience @audience_name
end


Then(/^I see an error telling me I can't create two audiences with the same description$/) do
  expect(page).to have_css(".alert-error")
end

When(/^I change the description of the audience "(.*?)" to "(.*?)"$/) do |old_description, new_description|
  @new_description = new_description
  basic_auth('discover', '')
  visit '/admin'
  click_link old_description
  fill_in 'Audience description', :with => new_description
  click_button 'Save changes'
  should_be_success
end

Then(/^the audience description should be updated on the main site$/) do
  visit '/'
  should_have_audience @new_description
end

When(/^I delete the audience "(.*?)"$/) do |audience_name|
  @audience_name = audience_name
  basic_auth('discover', '')
  visit '/admin'
  click_link @audience_name
  click_button 'Delete'
  should_be_success
end

Then(/^the audience is no longer shown on the main site$/) do
  visit '/'
  expect(page).not_to have_css('.audience', text: @audience_name)
end
