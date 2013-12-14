require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'json'

Dotenv.load
ENV['RACK_ENV'] ||= 'development'

['config', 'lib'].each do |path|
  Dir[File.dirname(__FILE__)+"/#{path}/**/*.rb"].sort.each { |file| require file }
end

Librato::Metrics.authenticate ENV.fetch('LIBRATO_EMAIL'), ENV.fetch('LIBRATO_API_KEY')

class LibratoGeckoboard < Sinatra::Application
  class BadRequest < StandardError
    attr_reader :cause
    def initialize(message, cause)
      super(message + ", cause is #{cause.inspect}")
      @cause = cause
    end
  end

  use Rack::Auth::Basic do |username, password|
    username == ENV.fetch('BASIC_AUTH_USERNAME') && password == ENV.fetch('BASIC_AUTH_PASSWORD')
  end

  def json(options)
    content_type :json
    status options.fetch(:status, 200)
    options.fetch(:content).to_json
  end

  get '/' do
    "Ok"
  end

  get '/metrics/poll/:type' do
    begin
      json :content => Gecko.for_type(params[:type]).new(params).widget
    rescue Gecko::Error => e
      raise BadRequest.new(e.message, e)
    end
  end

  error BadRequest do |e|
    logger.error e.message

    json :content => {:error => e.message}, :status => 400
  end
end
