Given(/^the site has the following audiences:$/) do |table|
  @audiences = table.raw.map(&:first)
  @audiences.each do |audience|
    #action = Discover::Action::CreateAudience.new(audience)
    #Discover::Repositories::Audience.handle(action)
  end
end

Then(/^I see the list of audiences clearly displayed for me to select from$/) do
  @audiences.each do |audience|
    page.should have_css(".audience", text: audience)
  end
end
