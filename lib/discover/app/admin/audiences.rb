require 'haml'

module Discover
  module App
    module Admin
      class Audiences < Admin::Base
        set :views, %w{views/admin/audiences views/admin views}
        set :method_override, true

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

        class Creator
          include Reactor

          def valid_audience(change)
            Changes::AudienceCreated.new(change.audience)
          end
        end

        class Editor < Struct.new(:slug)
          include Reactor

          def valid_audience(change)
            Changes::AudienceEdited.new(slug, change.audience)
          end
        end

        def downstream(queue)
          repository.apply(queue)
          AudienceHandler.new(self, '/').apply(queue).first
        end

        def validate(candidate)
          AudienceValidator.new(repository.active_audiences.map(&:description)).validate(candidate)
        end

        def find(slug)
          repository.audience_from_slug(slug)
        end

        def create_blank
          Audience.new
        end

        def create_from_params(params)
          Audience.new(params[:object][:description])
        end

        def update_from_params(object, params)
          object.with_description(params[:object][:description])
        end

        def delete_change(slug)
          Changes::AudienceDeleted.new(slug)
        end

        get '/new/?' do
          @object = create_blank
          haml :new
        end

        get '/:slug/?' do |slug|
          @object = find(slug)
          haml :edit
        end

        post '/?' do
          queue = validate(create_from_params(params))
          queue += Creator.new.apply(queue)
          downstream(queue)
        end

        post '/:slug/?' do |slug|
          queue = validate(update_from_params(find(slug), params))
          queue += Editor.new(slug).apply(queue)
          downstream(queue)
        end

        delete '/:slug/?' do |slug|
          downstream([delete_change(slug)])
        end
      end
    end
  end
end
