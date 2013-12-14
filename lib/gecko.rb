module Gecko
  extend self

  def for_type(type)
    const_get(type.to_s.camelize)
  end

  Error = Class.new(StandardError)
  InvalidArguments = Class.new(Error)

  class Base
    extend Forwardable
    def_delegators :'Librato::Metrics', :get_metric, :get_measurements

    def initialize(params)
      @params = params
    end

    def metric_name
      raise InvalidArguments, "metric_name unspecified" unless name = params[:metric_name]

      sanitize_librato_metric_name(name)
    end

    private

    def sanitize_librato_metric_name(metric_name)
      metric_name.gsub(/[^A-Za-z0-9_.:-]/, '')
    end

    attr_reader :params
  end
end
