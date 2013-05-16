module Discover
  module Persisted
    class Audience
      include Mongoid::Document
      include Mongoid::Timestamps

      field :description
      field :slug

      def domain_object
        Discover::Audience.new(description).freeze
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

    def apply(changes)
      changes.map { |c| c.apply(self) }
    end

    def active
      Persisted::Audience.all.map(&:domain_object)
    end
  end
end
