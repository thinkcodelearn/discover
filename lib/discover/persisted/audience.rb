module Discover
  NoAudienceFoundError = Class.new(Exception)
  NoTopicFoundError = Class.new(Exception)
  NoPlaceFoundError = Class.new(Exception)
  NothingFoundForSlugError = Class.new(Exception)

  module Persisted
    class Audience
      include Mongoid::Document
      include Mongoid::Timestamps

      field :description
      field :slug
      has_and_belongs_to_many :topics

      def domain_object
        Discover::Audience.new(description, slug, topics.map(&:slug)).freeze
      end

      def sync_topics!(topics)
        self.topics = topics.map do |slug|
          Persisted::Topic.find_by(slug: slug)
        end
        save!
      end
    end

    class Topic
      include Mongoid::Document
      include Mongoid::Timestamps

      field :name
      field :description
      field :slug
      has_and_belongs_to_many :audiences
      has_and_belongs_to_many :places

      def domain_object
        Discover::Topic.new(name, description, slug, places.map(&:slug)).freeze
      end

      def sync_places!(places)
        self.places = places.map do |slug|
          Persisted::Place.find_by(slug: slug)
        end
        save!
      end
    end

    class Place
      include Mongoid::Document
      include Mongoid::Timestamps

      field :slug
      field :yaml
      has_and_belongs_to_many :topics

      def domain_object
        YAML.load(yaml).freeze
      end
    end
  end

  class AudienceRepository
    include Reactor

    def audience_created(change)
      audience = Persisted::Audience.create!(
        description: change.audience.description,
        slug: change.audience.slug
      )
      audience.sync_topics!(change.audience.topics)
    end

    def audience_edited(change)
      audience = Persisted::Audience.find_by(slug: change.slug)
      audience.update_attributes(description: change.audience.description)
      audience.sync_topics!(change.audience.topics)
    end

    def audience_deleted(change)
      Persisted::Audience.find_by(slug: change.slug).destroy
    end

    def topic_created(change)
      topic = Persisted::Topic.create!(
        name: change.topic.name,
        description: change.topic.description,
        slug: change.topic.slug
      )
      topic.sync_places!(change.topic.places)
    end

    def topic_edited(change)
      topic = Persisted::Topic.find_by(slug: change.slug)
      topic.update_attributes(
        name: change.topic.name,
        description: change.topic.description
      )
      topic.sync_places!(change.topic.places)
    end

    def topic_deleted(change)
      Persisted::Topic.find_by(slug: change.slug).destroy
    end

    def place_created(change)
      Persisted::Place.create!(
        slug: change.place.slug,
        yaml: change.place.to_yaml)
    end

    def place_edited(change)
      place = Persisted::Place.find_by(slug: change.slug)
      place.update_attributes(yaml: change.place.to_yaml)
    end

    def place_deleted(change)
      Persisted::Place.find_by(slug: change.slug).destroy
    end

    def topics
      Persisted::Topic.all.map(&:domain_object)
    end

    def places
      Persisted::Place.all.map(&:domain_object).sort_by(&:name)
    end

    def active_audiences
      Persisted::Audience.all.map(&:domain_object)
    end

    def audience_from_slug(slug)
      Persisted::Audience.find_by(slug: slug).domain_object
    rescue Mongoid::Errors::DocumentNotFound
      raise NoAudienceFoundError
    end

    def topic_from_slug(slug)
      Persisted::Topic.find_by(slug: slug).domain_object
    rescue Mongoid::Errors::DocumentNotFound
      raise NoTopicFoundError
    end

    def place_from_slug(slug)
      Persisted::Place.find_by(slug: slug).domain_object
    rescue Mongoid::Errors::DocumentNotFound
      raise NoPlaceFoundError
    end
  end
end
