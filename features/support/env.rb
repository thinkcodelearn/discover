$: << 'lib'
$: << 'spec'

require 'bundler/setup'
require 'sinatra'

Sinatra::Application.environment = :test
Bundler.require :default, Sinatra::Application.environment

require 'mongoid_helper'

require 'capybara/cucumber'

require 'discover'

Capybara.app = Discover::App::Frontend
