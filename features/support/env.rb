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
