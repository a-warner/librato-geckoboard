module Gecko
  extend self

  def librato_to_gecko(librato_metric_response)
    source, measurements = librato_metric_response['measurements'].first
    items = measurements.sort_by { |m| m['measure_time'] }.map do |measurement|
      { :text => source, :value => measurement['value'] }
    end

    { :item => items, :type => 'reverse' }
  end
end
