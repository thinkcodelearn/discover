require 'haml'

module Discover
  module App
    module Admin
      class Topics < Admin::Base
        include Crud
        set :views, %w{views/admin/topics views/admin}

        class TopicHandler < Handler
          def invalid_topic(change)
            error(change.message)
          end

          def topic_created(change)
            app.flash[:notice] = "The topic '#{change.topic.name}' has been created."
            success
          end

          def topic_edited(change)
            app.flash[:notice] = "The topic '#{change.topic.name}' has been successfully edited."
            success
          end

          def topic_deleted(change)
            app.flash[:notice] = "The topic has been deleted."
            success
          end
        end

        class Creator
          include Reactor

          def valid_topic(change)
            Changes::TopicCreated.new(change.topic)
          end
        end

        class Editor < Struct.new(:slug)
          include Reactor

          def valid_topic(change)
            Changes::TopicEdited.new(slug, change.topic)
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
          TopicHandler.new(self, '/').apply(queue).first
        end

        def validator(candidate)
          TopicValidator.new((repository.topics - [candidate]).map(&:slug))
        end

        def find(slug)
          repository.topic_from_slug(slug)
        end

        def create_blank
          Topic.new
        end

        def create_from_params(params)
          Topic.new(params[:object][:name],
                    params[:object][:description],
                    nil,
                   [params[:object][:places]].flatten.compact)
        end

        def update_from_params(object, params)
          object.
            with_name(params[:object][:name]).
            with_description(params[:object][:description]).
            with_places([params[:object][:places]].flatten.compact)
        end

        def delete_change(slug)
          Changes::TopicDeleted.new(slug)
        end
      end
    end
  end
end
