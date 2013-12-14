module Gecko
  class NumberAndSecondaryStat < Base
    def response
      librato_response = get_metric(metric_name, :count => 2, :resolution => 60)

      source, measurements = librato_response['measurements'].first
      items = measurements.sort_by { |m| m['measure_time'] }.map do |measurement|
        { :text => source, :value => measurement['value'] }
      end

      { :item => items, :type => 'reverse' }
    end
  end
end
