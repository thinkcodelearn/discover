When(/^I visit the homepage of the site$/) do
  visit '/'
end

After { |s| save_and_open_page if s.failed? }
