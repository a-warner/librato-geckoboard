require 'rubygems'
require 'bundler/setup'
Bundler.require

Dotenv.load
ENV['RACK_ENV'] ||= 'development'

['config', 'lib'].each do |path|
  Dir[File.dirname(__FILE__)+"/#{path}/*.rb"].each { |file| require file }
end

Librato::Metrics.authenticate ENV.fetch('LIBRATO_EMAIL'), ENV.fetch('LIBRATO_API_KEY')

get '/' do
  "Ok"
end
