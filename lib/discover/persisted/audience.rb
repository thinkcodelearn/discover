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

      def domain_object
        Discover::Topic.new(name).freeze
      end
    end
  end

  class AudienceRepository
    def audience_created(change)
      Persisted::Audience.create!(
        description: change.audience.description,
        slug: change.audience.slug
      )
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

    def apply(changes)
      changes.map { |c| c.apply(self) }
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
