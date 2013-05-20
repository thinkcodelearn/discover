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
            {"Name" => "Job Centre Shirley St", "Information" => "Shirley St\nThamesmead\nE3 4AA", "Location" => "51.12345, -0.53943" },
            {"Name" => "Job Centre Evans St", "Information" => "Shirley St\nThamesmead\nE3 4AA", "Location" => "51.12345, -0.53943" },
            {"Name" => "Job Centre Row St", "Information" => "Shirley St\nThamesmead\nE3 4AA", "Location" => "51.12345, -0.53943" },
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
