$: << 'lib'

require 'bundler/setup'
require 'sinatra'

Bundler.require :default, Sinatra::Application.environment

Mongoid.load!("config/mongoid.yml")

require 'discover'

run Discover::App::Frontend
