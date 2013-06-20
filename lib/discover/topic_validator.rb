module Discover
  class TopicValidator < Struct.new(:existing_slugs)
    def validate(topic)
      [do_validate(topic)]
    end

    private

    def do_validate(topic)
      if topic.name.empty?
        return error("The topic does not have a valid name.")
      end

      if existing_slugs.include?(topic.slug)
        return error("There is already an topic with that url.")
      end

      Changes::ValidTopic.new(topic)
    end

    def error(message)
      Changes::InvalidTopic.new(message)
    end
  end
end
