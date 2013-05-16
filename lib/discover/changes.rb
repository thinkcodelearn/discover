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

    class AudienceCreated < Struct.new(:description)
      include Changes
    end
  end
end
