Then(/^I should see the topics I'm interested in$/) do
  @topics.each do |topic|
    page.should have_css(".topic", text: topic.name)
  end
end
