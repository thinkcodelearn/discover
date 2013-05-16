require 'mongoid'

ENV['MONGOID_ENV'] ||= 'test'
Mongoid.load!("config/mongoid.yml")

require 'database_cleaner'

# Including this here means that it gets called by cucumber as well, but
# it has no effect as rspec suites are not run.
RSpec.configure do |config|
  config.before(:suite) { DatabaseCleaner.strategy = :truncation }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
end
