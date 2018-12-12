require 'json'
require 'fluent/plugin/output'

class Fluent::Plugin::FileJsonOutput < Fluent::Plugin::Output
  Fluent::Plugin.register_output('file_json', self)

  config_param :file, :string, :default => '/root/fluentd-plugin-juniper-telemetry/fluentd_output.json'

  def initialize
    super
  end

  def configure(conf)
    super
  end

  def oprocess(tag, es)

    file = File.open(@file, 'ab')

    es.each do |time, record|
      file.puts record.to_json
    end

    file.close
  end
end
