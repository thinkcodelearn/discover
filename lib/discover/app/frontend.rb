require 'haml'

module Discover
  module App
    class Frontend < Sinatra::Application
      set :views, %w{views}

      before do
        @repository = Discover::AudienceRepository.new
        if @repository.active_audiences.empty?
          array = [
            [ "Youth"],
            [ "Schools"],
            [ "Groups"],
            [ "Activities"],
            [ "Transport"],
          ]

          @topics = array.map { |row| Discover::Topic.new(row.first) }
          @audience = Discover::Audience.new("I go to school in Thamesmead")

          audience_change = Discover::Changes::AudienceCreated.new(@audience)
          topic_changes =
            @topics.map { |t| Discover::Changes::TopicCreated.new(t) } +
            @topics.map { |t| Discover::Changes::TopicAttachedToAudience.new(@audience, t) }

          @places = YAML.load(File.read(File.dirname(__FILE__) + "/../../../spec/fixtures/places.yml"))
          p @places

          place_changes = @places.map { |p| Discover::Changes::PlaceAddedToTopic.new(@topics.first, p) }

          Discover::AudienceRepository.new.apply([ audience_change ] + topic_changes + place_changes)
        end
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
        @audiences = @repository.active_audiences
        haml :index
      end

      get '/css/screen.css' do
        scss :screen
      end

      get '/:audience/?' do |slug|
        @audience = @repository.audience_from_slug(slug)
        haml :audience
      end

      get '/:audience/:topic.atom/?' do |audience, topic|
        @audience = @repository.audience_from_slug(audience)
        @topic = @repository.topic_from_slug(topic)
        builder :topic
      end

      get '/:audience/:topic/?' do |audience, topic|
        @audience = @repository.audience_from_slug(audience)
        @topic = @repository.topic_from_slug(topic)
        haml :topic
      end
    end
  end
end
