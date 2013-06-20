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
            queue = validator.validate(create_from_params(params))
            queue += creator.apply(queue)
            downstream(queue)
          end

          host.post '/:slug/?' do |slug|
            queue = validator.validate(update_from_params(find(slug), params))
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
