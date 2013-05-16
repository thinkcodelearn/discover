$: << 'lib'

require 'sinatra'

require 'discover'

ENV['MONGOHQ_URL'] ||= "mongodb://localhost:27017/discover_development"

configure do
  Mongoid.configure do |config|
    conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
    uri = URI.parse(ENV['MONGOHQ_URL'])
    config.master = conn.db(uri.path.gsub(/^\//, ''))
  end
end


run Discover::App::Frontend
