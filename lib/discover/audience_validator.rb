module Discover
  class AudienceValidator < Struct.new(:existing_descriptions)
    def validate(audience)
      [do_validate(audience)]
    end

    private

    def do_validate(audience)
      if audience.description.empty?
        return error("The audience does not have a valid description.")
      end

      if existing_descriptions.include?(audience.description)
        return error("There is already an audience with that description.")
      end

      Changes::AudienceCreated.new(audience)
    end

    def error(description)
      Changes::CreationError.new(description)
    end
  end
end
