module Discover
  class PlaceValidator
    def validate(place)
      [do_validate(place)]
    end

    private

    def do_validate(place)
      if place.name.empty?
        return error("The topic does not have a valid name.")
      end
      Changes::ValidPlace.new(place)
    end

    def error(message)
      Changes::InvalidPlace.new(message)
    end
  end
end
