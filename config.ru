$: << 'lib'

require 'sinatra'

require 'discover'

run Discover::App::Frontend
