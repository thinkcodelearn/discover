module Discover
  class AudienceValidator < Struct.new(:existing_slugs)
    def validate(audience)
      [do_validate(audience)]
    end

    private

    def do_validate(audience)
      if audience.description.empty?
        return error("The audience does not have a valid description.")
      end

      if existing_slugs.include?(audience.slug)
        return error("There is already an audience with that url.")
      end

      Changes::ValidAudience.new(audience)
    end

    def error(message)
      Changes::InvalidAudience.new(message)
    end
  end
end
