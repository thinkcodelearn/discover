require 'haml'

module Discover
  module App
    module Admin
      class Audiences < Admin::Base
        set :views, %w{views/admin/audiences views/admin views}

        get '/new/?' do
          @object = Discover::Audience.new
          haml :new
        end

        class CreationHandler < Handler
          def creation_error(change)
            error(change.message)
          end

          def audience_created(change)
            success
          end
        end

        post '/?' do
          candidate = Audience.new(params[:object][:description])
          queue = AudienceValidator.new(audience_repository.active_audiences.map(&:description)).validate(candidate)
          audience_repository.apply(queue)
          CreationHandler.new(self, '/').apply(queue).first
        end
      end
    end
  end
end
