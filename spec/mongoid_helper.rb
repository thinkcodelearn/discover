require 'mongoid'

ENV['MONGOID_ENV'] ||= 'test'
Mongoid.load!("config/mongoid.yml")
