module Gecko
  extend self

  def librato_to_gecko(librato_metric_response)
    items = librato_metric_response['measurements'].map do |source, measurements|
      { :text => source, :value => measurements.map { |m| m['value'] }.inject(:+) }
    end

    { :item => items }
  end
end
