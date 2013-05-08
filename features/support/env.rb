$: << 'lib'

require 'sinatra'
require 'capybara/cucumber'

require 'discover'

Capybara.app = Discover::App::Frontend
