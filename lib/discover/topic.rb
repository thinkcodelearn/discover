module Discover
  class Topic < Struct.new(:name, :slug)
    def initialize(*)
      super
      self.slug ||= sluggify(name)
    end

    def sluggify(string)
      string.downcase.gsub(/\W/,'-')
    end
  end
end
