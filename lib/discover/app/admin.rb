require 'haml'

module Discover
  module App
    class Admin < Sinatra::Base
      helpers do
        def find_template(views, name, engine, &block)
          Array(views).each { |v| super(v, name, engine, &block) }
        end
      end

      set :views, %w{views/admin views}

      get '/' do
        haml :index
      end
    end
  end
end
