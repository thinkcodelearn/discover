module Discover
  class Place < Struct.new(:name, :slug, :information, :lat, :lng, :address, :telephone, :url, :email, :facebook, :twitter)
    DEFAULT = { :lat => '51.5040', :lng => '0.1142' }

    def initialize(*)
      super
      self.name ||= ''
      self.slug ||= sluggify(name)
      self.lat  ||= DEFAULT[:lat]
      self.lng  ||= DEFAULT[:lng]
    end

    def sluggify(string)
      string.downcase.gsub(/\W/,'-')
    end

    def with_slug(new_slug)
      self.class.new(name, new_slug, information, lat, lng, address, telephone, url, email, facebook, twitter)
    end
  end
end
