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

    class AudienceEdited < Struct.new(:slug, :audience)
      include Changes
    end

    class AudienceDeleted < Struct.new(:slug)
      include Changes
    end

    class TopicCreated < Struct.new(:topic)
      include Changes
    end

    class TopicEdited < Struct.new(:slug, :topic)
      include Changes
    end

    class TopicDeleted < Struct.new(:slug)
      include Changes
    end

    class ValidAudience < Struct.new(:audience)
      include Changes
    end

    class InvalidAudience < Struct.new(:message)
      include Changes
    end

    class ValidTopic < Struct.new(:topic)
      include Changes
    end

    class InvalidTopic < Struct.new(:message)
      include Changes
    end

    class ValidPlace < Struct.new(:place)
      include Changes
    end

    class InvalidPlace < Struct.new(:message)
      include Changes
    end

    class PlaceCreated < Struct.new(:place)
      include Changes
    end

    class PlaceEdited < Struct.new(:slug, :place)
      include Changes
    end

    class PlaceDeleted < Struct.new(:slug)
      include Changes
    end

    class ImageUploaded < Struct.new(:path, :bucket)
      include Changes
    end
  end
end
