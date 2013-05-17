module Discover
  module Changes
    def underscore(word)
      word.split(':').last.gsub(/([a-z])([A-Z])/,'\1_\2').downcase
    end

    def apply(handler, *args)
      method = underscore(self.class.to_s)
      if handler.respond_to?(method)
        handler.send(method, self, *args)
      else
        handler
      end
    end

    class AudienceCreated < Struct.new(:audience)
      include Changes
    end

    class TopicCreated < Struct.new(:topic)
      include Changes
    end

    class TopicAttachedToAudience < Struct.new(:audience, :topic)
      include Changes
    end

    class PlaceAddedToTopic < Struct.new(:topic, :place)
      include Changes
    end
  end
end
