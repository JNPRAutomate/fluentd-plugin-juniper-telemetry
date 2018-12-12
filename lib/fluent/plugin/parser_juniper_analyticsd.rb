require 'juniper_telemetry_lib.rb'
require 'fluent/plugin/parser'

module Fluent
  class Plugin
    class JuniperAnalyticsdParser < Parser

      Fluent::Plugin.register_parser("juniper_analyticsd", self)

      config_param :output_format, :string, :default => 'structured'

      # This method is called after config_params have read configuration parameters
      def configure(conf)
        super

        ## Check if "output_format" has a valid value
        unless  @output_format.to_s == "structured" ||
                @output_format.to_s == "flat" ||
                @output_format.to_s == "statsd"

          raise Fluent::ConfigError, "output_format value '#{@output_format}' is not valid. Must be : structured, flat or statsd"
        end
      end

      def parse(text)

        payload = JSON.parse(text)

        ## Extract contextual info
        record_type = payload["record-type"]
        record_time = payload["time"]
        device_name = payload["router-id"]
        port_name = payload["port"]

        ## Record time is in microsecond and until 0.14 Fluentd do not support lower than 1s
        ## We need to trim record time for now to fit fluentd
        json_time = (record_time/1000000).to_i

        if record_type == 'traffic-stats'

          ## Delete contextual info
          payload.delete("record-type")
          payload.delete("time")
          payload.delete("router-id")
          payload.delete("port")

          payload.each do |key, value|

            # Save all info extracted on a list
            sensor_data = []
            sensor_data.push({ 'device' => device_name })
            sensor_data.push({ 'interface' => port_name })
            sensor_data.push({ 'type' => record_type + '.' + key })
            sensor_data.push({ 'value' => value })

            record = build_record(output_format, sensor_data)
            yield json_time, record
          end
        elsif record_type == 'queue-stats'

          ## Delete contextual info
          payload.delete("record-type")
          payload.delete("time")
          payload.delete("router-id")
          payload.delete("port")

          payload.each do |key, value|

            sensor_data = []
            sensor_data.push({ 'device' => device_name })
            sensor_data.push({ 'interface' => port_name })
            sensor_data.push({ 'type' => record_type + '.' + key })
            sensor_data.push({ 'value' => value })

            record = build_record(output_format, sensor_data)
            yield json_time, record
          end
        else
          $log.warn "Recard type '#{record_type}' not supported"
        end
      end
    end
  end
end
