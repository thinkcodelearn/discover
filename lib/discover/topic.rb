module Discover
  class Topic < Struct.new(:name, :slug, :places)
    def initialize(*)
      super
      self.name ||= ''
      self.slug ||= sluggify(name)
      self.places ||= []
    end

    def sluggify(string)
      string.downcase.gsub(/\W/,'-')
    end

    def with_name(new_name)
      self.class.new(new_name, slug, places)
    end
  end
end
