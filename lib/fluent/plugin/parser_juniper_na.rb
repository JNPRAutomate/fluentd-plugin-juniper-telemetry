require 'fluent/plugin/parser'

module Fluent
    class Plugin
        class JuniperNaParser < Parser

            Fluent::Plugin.register_parser("juniper_na", self)

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
            # This is the main method. The input "text" is the unit of data to be parsed.
            # If this is the in_tail plugin, it would be a line. If this is for in_syslog,
            # it is a single syslog message.
            def parse(text)

                resources = JSON.parse(text)
                time = Fluent::Engine.now

                resources.each do |resource|
                    resource["Resources"].each do |data|
                        name = data["Res_ID"]

                        name_h = Hash.new
                        type = ''
                        if output_format.to_s == 'flat' ||
                            output_format.to_s == 'statsd'
                            name_gr = name_flat(name)

                        elsif output_format.to_s == 'structured'
                            name_h = name_hash(name)
                            type = name_h['type']

                        else
                            $log.warn "Output_format '#{output_format.to_s}' not supported."
                        end

                        ##
                        ## Extract data
                        ## First check if the value is a hash or not
                        ##
                        data["Data"].each do |key, value|
                            if value.is_a?(Hash)

                                ## If data is within a Hash, extract all values and construct new keys
                                data["Data"][key].each do |key2, value2|
                                    sub_type = key + "." + key2

                                    record = {}
                                    if output_format.to_s == 'flat'
                                        full_name = "#{name_gr}.#{sub_type}"
                                        record[full_name.downcase]= value2

                                    elsif output_format.to_s == 'structured'
                                        name_h['type'] = type + sub_type
                                        record['value'] = value2
                                        record.merge!(name_h)

                                    elsif output_format.to_s == 'statsd'
                                        full_name = "#{name_gr}.#{sub_type}"
                                        record[:statsd_type] = 'gauge'
                                        record[:statsd_key] = full_name.downcase
                                        record[:statsd_gauge] = value2
                                    else
                                        $log.warn "Output_format '#{output_format.to_s}' not supported for #{sub_type}"
                                    end

                                    yield time, record
                                end
                            else
                                record = {}
                                sub_type = key

                                if output_format.to_s == 'flat'
                                    full_name = "#{name_gr}.#{sub_type}"
                                    record[full_name.downcase]= value

                                elsif output_format.to_s == 'structured'
                                    name_h['type'] = type + sub_type
                                    record['value'] = value
                                    record.merge!(name_h)

                                elsif output_format.to_s == 'statsd'
                                    full_name = "#{name_gr}.#{sub_type}"
                                    record[:statsd_type] = 'gauge'
                                    record[:statsd_key] = full_name.downcase
                                    record[:statsd_gauge] = value
                                else
                                    $log.warn "Output_format '#{output_format.to_s}' not supported for #{sub_type}"
                                end

                                yield time, record
                            end
                        end
                    end
                end
            end

            def name_flat(res_id)

                res_id.sub!(/^\//, "")

                # ## Replace all / and : per .
                res_id.gsub!('/', '.')
                res_id.gsub!(':', '.')

                return res_id
            end

            def name_hash(res_id)

                # Parse Res_ID and convert to hash
                # 1- Remove leading /
                # 2- Split String by /
                # 3- for each attribute split by : to extract key / value

                res_id.sub!(/^\//, "")
                attributes = res_id.split("/")

                res_hash = Hash.new
                type = ''

                attributes.each do |attribute|
                    key_value = attribute.split(":")
                    res_hash[key_value[0].downcase] = key_value[1].downcase

                    if key_value[0].downcase != 'device'
                        type = type + key_value[0].downcase + '.'
                    end
                end

                res_hash['type'] = type

                return res_hash
            end
        end
    end
end
