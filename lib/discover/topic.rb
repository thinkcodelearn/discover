module Discover
  class Topic < Struct.new(:name, :slug, :places)
    def initialize(*)
      super
      self.slug ||= sluggify(name)
      self.places ||= []
    end

    def sluggify(string)
      string.downcase.gsub(/\W/,'-')
    end
  end
end
