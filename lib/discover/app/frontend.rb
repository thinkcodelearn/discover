require 'haml'

module Discover
  module App
    class Frontend < Sinatra::Base
      set :views, %w{views}
      set :static, true
      set :public_folder, ::File.join(Dir.pwd, 'public')

      def repository
        @audience_repository ||= Discover::AudienceRepository.new
      end

      helpers do
        def find_template(views, name, engine, &block)
          Array(views).each { |v| super(v, name, engine, &block) }
        end

        def topic_path(audience, topic)
          ['/', audience.slug, '/', topic.slug].join
        end
      end

      get '/' do
        @audiences = repository.active_audiences
        haml :index
      end

      get '/css/screen.css' do
        scss :screen
      end

      get '/:audience/?' do |slug|
        @audience = repository.audience_from_slug(slug)
        haml :audience
      end

      get '/:audience/:topic.atom/?' do |audience, topic|
        @audience = repository.audience_from_slug(audience)
        @topic = repository.topic_from_slug(topic)
        builder :topic
      end

      get '/:audience/:topic/?' do |audience, topic|
        @audience = repository.audience_from_slug(audience)
        @topic = repository.topic_from_slug(topic)
        haml :topic
      end
    end
  end
end
