module Discover
  NoAudienceFoundError = Class.new(Exception)
  NoTopicFoundError = Class.new(Exception)
  NothingFoundForSlugError = Class.new(Exception)

  module Persisted
    class Audience
      include Mongoid::Document
      include Mongoid::Timestamps

      field :description
      field :slug
      has_and_belongs_to_many :topics

      def domain_object
        Discover::Audience.new(description, slug, topics.map(&:domain_object)).freeze
      end
    end

    class Topic
      include Mongoid::Document
      include Mongoid::Timestamps

      field :name
      field :slug
      has_and_belongs_to_many :audiences
      field :places, type: Array, default: []

      def domain_object
        Discover::Topic.new(name, slug, places_domain_object).freeze
      end

      def places_domain_object
        places.map { |p| YAML.load(p) }
      end
    end
  end

  class AudienceRepository
    include Reactor

    def audience_created(change)
      Persisted::Audience.create!(
        description: change.audience.description,
        slug: change.audience.slug
      )
    end

    def audience_edited(change)
      audience = Persisted::Audience.find_by(slug: change.slug)
      audience.update_attributes(:description => change.audience.description)
      audience.save!
    end

    def topic_created(change)
      Persisted::Topic.create!(
        name: change.topic.name,
        slug: change.topic.slug
      )
    end

    def topic_attached_to_audience(change)
      topic = Persisted::Topic.find_by(slug: change.topic.slug)
      audience = Persisted::Audience.find_by(slug: change.audience.slug)
      audience.topics << topic
      audience.save!
    end

    def place_added_to_topic(change)
      topic = Persisted::Topic.find_by(slug: change.topic.slug)
      topic.places << change.place.to_yaml
      topic.save!
    end

    def topics
      Persisted::Topic.all.map(&:domain_object)
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
  end
end
