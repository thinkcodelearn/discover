module Discover
  class Topic < Struct.new(:name, :description, :slug, :places, :image)
    def initialize(*)
      super
      self.name ||= ''
      self.description ||= ''
      self.slug ||= sluggify(name)
      self.places ||= []
      self.image ||= Image.new.url
    end

    def sluggify(string)
      string.downcase.gsub(/\W/,'-')
    end

    def with_name(new_name)
      self.class.new(new_name, description, slug, places, image)
    end

    def with_description(new_description)
      self.class.new(name, new_description, slug, places, image)
    end

    def with_places(new_places)
      self.class.new(name, description, slug, new_places, image)
    end

    def with_image(new_image)
      self.class.new(name, description, slug, places, Image.new(new_image, Image::DEFAULT_BUCKET).url)
    end

    def places_by_name(repository)
      places.map {|slug| repository.place_from_slug(slug) }.sort_by(&:name)
    end
  end
end
