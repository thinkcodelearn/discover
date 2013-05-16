$: << 'lib'

require 'bundler/setup'

require 'sinatra'
require 'capybara/cucumber'

Sinatra::Application.environment = :test
Bundler.require :default, Sinatra::Application.environment

require 'discover'

begin
  require 'database_cleaner'
  require 'database_cleaner/cucumber'

  DatabaseCleaner.strategy = :truncation

  Before { DatabaseCleaner.start }
  After  { DatabaseCleaner.clean }

rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Mongoid.load!("config/mongoid.yml")

Capybara.app = Discover::App::Frontend
