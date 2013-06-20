require 'haml'

module Discover
  module App
    module Admin
      class Places < Admin::Base
        include Crud
        set :views, %w{views/admin/places views/admin}

        class PlaceHandler < Handler
          def invalid_place(change)
            error(change.message)
          end

          def place_created(change)
            app.flash[:notice] = "The place '#{change.place.name}' has been created."
            success
          end

          def place_edited(change)
            app.flash[:notice] = "The place '#{change.place.name}' has been successfully edited."
            success
          end

          def place_deleted(change)
            app.flash[:notice] = "The place has been deleted."
            success
          end
        end

        class Creator
          include Reactor

          def valid_place(change)
            Changes::PlaceCreated.new(change.place)
          end
        end

        class Editor < Struct.new(:slug)
          include Reactor

          def valid_place(change)
            Changes::PlaceEdited.new(slug, change.place)
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
          PlaceHandler.new(self, '/').apply(queue).first
        end

        def validator(candidate)
          PlaceValidator.new
        end

        def find(slug)
          repository.place_from_slug(slug)
        end

        def create_blank
          Place.new
        end

        def create_from_params(params)
          Place.new(
            params[:object][:name],
            params[:object][:slug],
            params[:object][:information],
            params[:object][:lat],
            params[:object][:lng],
            params[:object][:address],
            params[:object][:telephone],
            params[:object][:url],
            params[:object][:email],
            params[:object][:facebook],
            params[:object][:twitter])
        end

        def update_from_params(object, params)
          create_from_params(params).with_slug(object.slug)
        end

        def delete_change(slug)
          Changes::PlaceDeleted.new(slug)
        end
      end
    end
  end
end
