module Discover
  class Audience < Struct.new(:description, :slug, :topics)
    def initialize(*)
      super
      self.description ||= ''
      self.slug ||= sluggify(description)
      self.topics ||= []
    end

    def sluggify(string)
      string.downcase.gsub(/\W/,'-')
    end

    def with_description(new_description)
      self.class.new(new_description, slug, topics)
    end

    def with_topics(new_topics)
      self.class.new(description, slug, new_topics)
    end
  end
end
