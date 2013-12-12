require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'json'

Dotenv.load
ENV['RACK_ENV'] ||= 'development'

['config', 'lib'].each do |path|
  Dir[File.dirname(__FILE__)+"/#{path}/*.rb"].each { |file| require file }
end

Librato::Metrics.authenticate ENV.fetch('LIBRATO_EMAIL'), ENV.fetch('LIBRATO_API_KEY')

class LibratoGeckoboard < Sinatra::Application
  BadRequest = Class.new(StandardError)

  def json(options)
    content_type :json
    status options.fetch(:status, 200)
    options.fetch(:content).to_json
  end

  def sanitize_librato_metric_name(metric_name)
    metric_name.gsub(/[^A-Za-z0-9_.:-]/, '')
  end

  get '/' do
    "Ok"
  end

  get '/metrics/poll' do
    raise BadRequest, "metric_name unspecified" unless metric_name = params[:metric_name]
    metric_name = sanitize_librato_metric_name(metric_name)

    librato_response = Librato::Metrics.get_metric(metric_name, :count => 1, :resolution => 60)

    json :content => Gecko.librato_to_gecko(librato_response)
  end

  error BadRequest do |e|
    logger.error e.message

    json :content => {:error => e.message}, :status => 400
  end
end
