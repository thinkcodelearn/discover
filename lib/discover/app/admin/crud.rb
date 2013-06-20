require 'haml'

module Discover
  module App
    module Admin
      module Crud
        def self.included(host)
          host.set :method_override, true

          host.get '/new/?' do
            @object = create_blank
            haml :new
          end

          host.get '/:slug/?' do |slug|
            @object = find(slug)
            haml :edit
          end

          host.post '/?' do
            queue = validator(nil).validate(create_from_params(params))
            queue += creator.apply(queue)
            downstream(queue)
          end

          host.post '/:slug/?' do |slug|
            candidate = find(slug)
            queue = validator(candidate).
              validate(update_from_params(candidate, params))
            queue += editor(slug).apply(queue)
            downstream(queue)
          end

          host.delete '/:slug/?' do |slug|
            downstream([delete_change(slug)])
          end
        end
      end
    end
  end
end
