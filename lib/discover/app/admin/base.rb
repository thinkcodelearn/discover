require 'haml'

module Discover
  module App
    module Admin
      class Base < Sinatra::Base
        def repository
          @audience_repository ||= Discover::AudienceRepository.new
        end

        before do
          @audiences = repository.active_audiences
          @topics = repository.topics
          @places = repository.places
        end

        helpers do
          def find_template(views, name, engine, &block)
            Array(views).each { |v| super(v, name, engine, &block) }
          end
        end

        set :views, %w{views/admin views}

        get '/' do
          haml :index
        end
      end
    end
  end
end
