Given(/^I have uploaded an image called 'job\-centres\.png'$/) do
  basic_auth('discover', '')
  visit '/admin/images/uploaded?bucket=discover-thamesmead-website-images&key=uploads%2Ffoo%2Fjob-centres.png'
end
