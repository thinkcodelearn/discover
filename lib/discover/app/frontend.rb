require 'haml'

module Discover
  module App
    class Frontend < Sinatra::Application
      set :views, %w{views}

      before do
        @repository = Discover::AudienceRepository.new
        if @repository.active_audiences.empty?
          array = [
            [ "Job Centres"],
            [ "Post Offices"],
          ]

          @topics = array.map { |row| Discover::Topic.new(row.first) }
          @audience = Discover::Audience.new("I am looking for work")

          audience_change = Discover::Changes::AudienceCreated.new(@audience)
          topic_changes =
            @topics.map { |t| Discover::Changes::TopicCreated.new(t) } +
            @topics.map { |t| Discover::Changes::TopicAttachedToAudience.new(@audience, t) }

          Discover::AudienceRepository.new.apply([ audience_change ] + topic_changes)

          places = [
            {"Name" => "Job Centre Shirley St", "Information" => "Shirley St\nThamesmead\nE3 4AA", "Location" => "51.5040, 0.1234" },
            {"Name" => "Job Centre Evans St", "Information" => "Shirley St\nThamesmead\nE3 4AA", "Location" => "51.4990, 0.0999" },
            {"Name" => "Job Centre Row St", "Information" => "Shirley St\nThamesmead\nE3 4AA", "Location" => "51.5111, 0.1199" },
          ]

          @places = places.map do |row|
            lat, lng = row['Location'].split(', ')
            Discover::Place.new(row['Name'], row['Information'], lat, lng)
          end
          @topic = Discover::Topic.new("Job Centres")

          topic_change = Discover::Changes::TopicCreated.new(@topic)
          place_changes = @places.map { |p| Discover::Changes::PlaceAddedToTopic.new(@topic, p) }
          Discover::AudienceRepository.new.apply([ topic_change ] + place_changes)
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
