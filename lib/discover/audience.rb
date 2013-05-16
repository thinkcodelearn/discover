module Discover
  class Audience < Struct.new(:description, :slug, :topics)
    def initialize(*)
      super
      self.slug ||= sluggify(description)
      self.topics ||= []
    end

    def sluggify(string)
      string.downcase.gsub(/\W/,'-')
    end
  end
end
