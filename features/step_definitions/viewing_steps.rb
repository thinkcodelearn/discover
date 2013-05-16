When(/^I visit the homepage of the site$/) do
  visit '/'
end

When(/^I select the audience "(.*?)" from the home page$/) do |audience|
  visit '/'
  click_on audience
end

After { |s| save_and_open_page if s.failed? }
