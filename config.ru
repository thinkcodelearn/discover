$: << 'lib'

require 'bundler/setup'
require 'sinatra'

Bundler.require :default, Sinatra::Application.environment

Mongoid.load!("config/mongoid.yml")

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY']
  }
  config.fog_directory  = ENV['AWS_FOG_DIRECTORY'] # bucket name
end

require 'discover'

run new_app
