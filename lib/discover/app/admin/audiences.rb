require 'haml'

module Discover
  module App
    module Admin
      class Audiences < Admin::Base
        set :views, %w{views/admin/audiences views/admin views}
        set :method_override, true

        get '/new/?' do
          @object = Discover::Audience.new
          haml :new
        end

        get '/:slug/?' do |slug|
          @object = audience_repository.audience_from_slug(slug)
          haml :edit
        end

        class AudienceHandler < Handler
          def invalid_audience(change)
            error(change.message)
          end

          def audience_created(change)
            success
          end

          def audience_edited(change)
            success
          end

          def audience_deleted(change)
            app.flash[:notice] = "The audience has been deleted."
            success
          end
        end

        class AudienceCreator
          include Reactor

          def valid_audience(change)
            Changes::AudienceCreated.new(change.audience)
          end
        end

        class AudienceEditor < Struct.new(:slug)
          include Reactor

          def valid_audience(change)
            Changes::AudienceEdited.new(slug, change.audience)
          end
        end

        post '/?' do
          candidate = Audience.new(params[:object][:description])
          queue = AudienceValidator.new(audience_repository.active_audiences.map(&:description)).validate(candidate)
          queue += AudienceCreator.new.apply(queue)
          audience_repository.apply(queue)
          AudienceHandler.new(self, '/').apply(queue).first
        end

        post '/:slug/?' do |slug|
          existing = audience_repository.audience_from_slug(slug)
          candidate = existing.with_description(params[:object][:description])
          queue = AudienceValidator.new(audience_repository.active_audiences.map(&:description)).validate(candidate)
          queue += AudienceEditor.new(slug).apply(queue)
          audience_repository.apply(queue)
          AudienceHandler.new(self, '/').apply(queue).first
        end

        delete '/:slug/?' do |slug|
          queue = [Changes::AudienceDeleted.new(slug)]
          audience_repository.apply(queue)
          AudienceHandler.new(self, '/').apply(queue).first
        end
      end
    end
  end
end
