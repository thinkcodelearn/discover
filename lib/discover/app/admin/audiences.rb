require 'haml'

module Discover
  module App
    module Admin
      class Audiences < Admin::Base
        include Crud
        set :views, %w{views/admin/audiences views/admin}

        class AudienceHandler < Handler
          def invalid_audience(change)
            error(change.message)
          end

          def audience_created(change)
            app.flash[:notice] = "The audience '#{change.audience.description}' has been created."
            success
          end

          def audience_edited(change)
            app.flash[:notice] = "The audience '#{change.audience.description}' has been successfully edited."
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

        def creator
          Creator.new
        end

        def editor(slug)
          Editor.new(slug)
        end

        def downstream(queue)
          repository.apply(queue)
          AudienceHandler.new(self, '/').apply(queue).first
        end

        def validator(candidate)
          AudienceValidator.new((repository.active_audiences - [candidate]).map(&:slug))
        end

        def find(slug)
          repository.audience_from_slug(slug)
        end

        def create_blank
          Audience.new
        end

        def create_from_params(params)
          Audience.new(params[:object][:description], nil,
                       [params[:object][:topics]].flatten.compact)
        end

        def update_from_params(object, params)
          object.
            with_description(params[:object][:description]).
            with_topics([params[:object][:topics]].flatten.compact)
        end

        def delete_change(slug)
          Changes::AudienceDeleted.new(slug)
        end
      end
    end
  end
end
