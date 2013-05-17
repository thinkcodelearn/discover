require 'haml'

module Discover
  module App
    class Frontend < Sinatra::Application
      set :views, %w{views}

      before do
        @repository = Discover::AudienceRepository.new
      end

      helpers do
        def find_template(views, name, engine, &block)
          Array(views).each { |v| super(v, name, engine, &block) }
        end
      end

      get '/' do
        @audiences = @repository.active_audiences
        haml :index
      end

      get '/:slug/?' do |slug|
        @thing = @repository.from_slug(slug)
        # FIXME: remove conditional
        if @thing.is_a?(Audience)
          @audience = @thing
          haml :audience
        else
          @topic = @thing
          haml :topic
        end
      end

      get '/css/screen.css' do
        scss :screen
      end
    end
  end
end
