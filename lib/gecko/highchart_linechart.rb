module Gecko
  class HighchartLinechart < Base
    def response
      linechart_response(metric_names.map do |name|
        create_series(name, get_measurements(name, :start_time => Time.now - (30 * 60), :resolution => 60))
      end)
    end

    private

    def create_series(name, measurements)
      data = measurements.values.first.sort_by { |m| m['measure_time'] }.map do |m|
        [milliseconds(m['measure_time']), m['value']]
      end

      { name: name, data: data }
    end

    def linechart_response(series)
      { chart: { renderTo: 'container' },
        title: { text: params[:chart_title] || 'Untitled' },
        credits: { enabled: false },
        xAxis: { type: 'datetime' },
        series: series }
    end

    def milliseconds(time)
      time.to_i * 1000
    end
  end
end
