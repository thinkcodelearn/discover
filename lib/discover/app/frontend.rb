module Discover
  module App
    class Frontend < Sinatra::Application
      get '/' do
        haml :index
      end
    end
  end
end
