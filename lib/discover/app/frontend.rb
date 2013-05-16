require 'haml'

module Discover
  module App
    class Frontend < Sinatra::Application
      set :views, %w{views}

      before do
        @audience_repository = Discover::AudienceRepository.new
      end

      helpers do
        def find_template(views, name, engine, &block)
          Array(views).each { |v| super(v, name, engine, &block) }
        end
      end

      get '/' do
        @audiences = @audience_repository.active
        haml :index
      end

      get '/:audience_slug/?' do |slug|
        @audience = @audience_repository.from_slug(slug)
        haml :audience
      end

      get '/css/screen.css' do
        scss :screen
      end
    end
  end
end
