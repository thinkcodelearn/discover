require 'haml'

module Discover
  module App
    module Admin
      class ImageUploader < CarrierWave::Uploader::Base
        include CarrierWaveDirect::Uploader
      end

      class Images < Admin::Base
        set :views, %w{views/admin/images views/admin}

        get '/new/?' do
          @uploader = ImageUploader.new
          @uploader.success_action_redirect = request.url.sub(/new/, 'uploaded')
          haml :new
        end

        get '/uploaded/?' do
          queue = [Changes::ImageUploaded.new(params['key'], params['bucket'])]
          repository.apply(queue)
          flash[:notice] = "The image was successfully uploaded."
          redirect to('/new')
        end
      end
    end
  end
end
