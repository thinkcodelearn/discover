require 'bundler/setup'

Bundler.require :default

task :spec do
  sh 'rspec'
end

task :cucumber do
  sh 'cucumber'
end

task :default => [:spec, :cucumber]
