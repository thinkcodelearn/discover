require 'haml'

module Discover
  module App
    module Admin
      class Base < Sinatra::Base
        def audience_repository
          @audience_repository ||= Discover::AudienceRepository.new
        end

        before do
          @audiences = audience_repository.active_audiences
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
