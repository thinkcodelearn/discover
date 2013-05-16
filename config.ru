$: << 'lib'

require 'sinatra'

require 'discover'

Mongoid.load!("config/mongoid.yml")

run Discover::App::Frontend
