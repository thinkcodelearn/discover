module Discover
  module App
    class Handler < Struct.new(:app, :redirect_location)
      include Reactor

      def success
        app.redirect app.to(redirect_location)
      end

      def unacceptable
        app.halt 406
      end

      def error(message)
        app.flash[:error] = message
        app.redirect app.to(redirect_location)
      end

      def notice(message)
        app.flash[:notice] = message
        app.redirect app.to(redirect_location)
      end
    end
  end
end
