$: << 'lib'
$: << 'spec'

require 'bundler/setup'
require 'sinatra/base'

Sinatra::Application.environment = :test
Bundler.require :default, Sinatra::Application.environment

require 'mongoid_helper'

require 'capybara/cucumber'

require 'discover'

Capybara.app = new_app

def should_have_audience(audience)
  page.should have_css(".audience", text: audience)
end

def should_have_topic(topic)
  page.should have_css(".topic", text: topic)
end

def basic_auth(name, password)
  if page.driver.respond_to?(:basic_auth)
    page.driver.basic_auth(name, password)
  elsif page.driver.respond_to?(:basic_authorize)
    page.driver.basic_authorize(name, password)
  elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
    page.driver.browser.basic_authorize(name, password)
  else
    raise "I don't know how to log in!"
  end
end

def should_be_success
  expect(page).to have_css(".nav")
end

def places_from(table)
  table.transpose.hashes.map do |row|
    lat, lng = row['Location'].split(', ')
    Discover::Place.new(
      row['Name'],
      nil,
      row['Information'],
      lat,
      lng,
      row['Address'],
      row['Telephone'],
      row['URL'],
      row['E-mail'],
      row['Facebook'],
      row['Twitter'])
  end
end
