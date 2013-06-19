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

        post '/?' do
          change = Discover::Changes::AudienceCreated.new(Audience.new(params[:object][:description]))
          audience_repository.apply([change])
          redirect('/admin/')
        end
      end
    end
  end
end
