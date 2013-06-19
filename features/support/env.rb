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
