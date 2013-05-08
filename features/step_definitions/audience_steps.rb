Audience = Struct.new :description

Given(/^the site has the following audiences:$/) do |table|
  @audiences = table.raw.map do |row|
    Audience.new(row.first)
  end
end

Then(/^I see the list of audiences clearly displayed for me to select from$/) do
  @audiences.each do |audience|
    page.should have_css(".audience", text: audience.description)
  end
end
