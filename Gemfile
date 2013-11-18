source "https://rubygems.org"
ruby "1.9.3"

gem "rake"
gem "sinatra"
gem "haml"
gem "sass"
gem "kramdown"
gem 'json', '~> 1.7.7'

gem 'bson_ext'
gem 'mongoid', '~> 3.0'

gem "puma"
gem "rack-usermanual"
gem 'rack-flash3'

gem 'unf'
# This version has a particlar fix we need for sinatra
# See https://github.com/dwilkie/carrierwave_direct/pull/96
gem 'carrierwave_direct', :git => 'git://github.com/asmatameem/carrierwave_direct.git', :ref => 'b6fa0e7f87f2fbb1cfa79f4605606609b36c8a1c'

group :test do
  gem "cucumber", "~> 1.2.0"
  gem "rspec"
  gem "capybara"
  gem "launchy"
  gem "database_cleaner"
end
