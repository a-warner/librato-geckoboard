module Gecko
  class HighchartLinechart < Base
    def response
      linechart_response(metric_names.map do |name|
        create_series(name, get_measurements(name, :start_time => Time.now - (30 * 60), :resolution => 60))
      end)
    end

    def create_series(name, measurements)
      { name: name, data: measurements.values.first.sort_by { |m| m['measure_time'] }.map { |m| m['value'] } }
    end

    def linechart_response(series)
      { chart: { renderTo: 'container' },
        title: { text: params[:chart_title] || 'Untitled' },
        credits: { enabled: false },
        series: series }
    end
  end
end
