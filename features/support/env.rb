$: << 'lib'

require 'bundler/setup'
require 'sinatra'

Sinatra::Application.environment = :test
Bundler.require :default, Sinatra::Application.environment

Mongoid.load!("config/mongoid.yml")

require 'capybara/cucumber'

require 'discover'

Capybara.app = Discover::App::Frontend
