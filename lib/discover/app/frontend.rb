require 'haml'
require 'sass'

module Discover
  module App
    class Frontend < Sinatra::Application
      set :views, %w{views}

      helpers do
        def find_template(views, name, engine, &block)
          Array(views).each { |v| super(v, name, engine, &block) }
        end
      end

      get '/' do
        haml :index
      end

      get '/css/screen.css' do
        scss :screen
      end
    end
  end
end
