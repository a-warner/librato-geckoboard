module Gecko
  extend self

  def for_type(type)
    const_get(type.to_s.camelize)
  end

  Error = Class.new(StandardError)
  InvalidArguments = Class.new(Error)
  MetricNotFound = Class.new(Error)

  class Base
    extend Forwardable
    def_delegators :'Librato::Metrics', :get_metric, :get_measurements

    def initialize(params)
      @params = params
    end

    def metric_name
      names = metric_names
      raise InvalidArguments, "only 1 metric name expected" unless names.one?

      names.first
    end

    def metric_names
      names = Array(params[:metric_name]).flatten.compact
      raise InvalidArguments, "metric_name unspecified" unless names.any?

      names.map(&method(:sanitize_librato_metric_name))
    end

    def widget
      response
    rescue Librato::Metrics::NotFound => e
      raise MetricNotFound, e.inspect
    end

    private

    def sanitize_librato_metric_name(metric_name)
      metric_name.gsub(/[^A-Za-z0-9_.:-]/, '')
    end

    attr_reader :params
  end
end
