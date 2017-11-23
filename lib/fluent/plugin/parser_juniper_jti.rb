require 'cpu_memory_utilization.pb'
require 'fabric.pb'
require 'firewall.pb'
require 'fluent/parser'
require 'inline_jflow.pb'
require 'juniper_telemetry_lib.rb'
require 'lsp_mon.pb'
require 'lsp_stats.pb'
require 'npu_memory_utilization.pb'
require 'npu_utilization.pb'
require 'optics.pb'
require 'packet_stats.pb'
require 'pbj.pb'
require 'port.pb'
require 'port_exp.pb'
require 'protobuf'
require 'qmon.pb'
require 'logical_port.pb'
require 'telemetry_top.pb'


module Fluent
    class TextParser
        class JuniperJtiParser < Parser
            
            # Register this parser as "juniper_jti"
            Plugin.register_parser("juniper_jti", self)
            
            config_param :output_format, :string, :default => 'structured'
            
            
            
            # This method is called after config_params have read configuration parameters
            def configure(conf)
                super
        
                ## Check if "output_format" has a valid value
                unless  @output_format.to_s == "structured" ||
                        @output_format.to_s == "flat" ||
                        @output_format.to_s == "statsd"
        
                  raise ConfigError, "output_format value '#{@output_format}' is not valid. Must be : structured, flat or statsd"
                end
            end
            
            
            
            # This is the main method. The input "text" is the unit of data to be parsed.
            
            #    The JTI sensor data that we get from the device will have the following high-level structure ...
            #    
            #        system_id: "nanostring:3.3.3.2"
            #        component_id: 1
            #        sensor_name: "SENSOR1:/junos/system/linecard/interface/:/junos/system/linecard/interface/:PFE"
            #        sequence_number: 97
            #        timestamp: 1510774932270
            #        version_major: 1
            #        version_minor: 1
            #        enterprise {
            #          [juniperNetworks] {
            #            [jnpr_interface_ext] {
            #              interface_stats {
            #                if_name: "xe-1/0/0"
            #                init_time: 1510755787
            #                snmp_if_index: 17555
            #                egress_queue_info {
            #                  queue_number: 0
            #                  packets: 0
            #                  bytes: 0
            #                  tail_drop_packets: 0
            #                  rl_drop_packets: 0
            #                  rl_drop_bytes: 0
            #                  red_drop_packets: 0
            #                  red_drop_bytes: 0
            #                  avg_buffer_occupancy: 0
            #                  cur_buffer_occupancy: 0
            #                  peak_buffer_occupancy: 0
            #                  allocated_buffer_size: 120061952
            #                }
            #                ...
            def parse(text)

                # Decode GBP packet.
                jti_msg =  TelemetryStream.decode(text)
                #$log.debug  "Value of 'jti_msg': '#{jti_msg}'"
                
                resource = ""
                
                # Extract device name & timestamp from the JTI sensor data.
                device_name = jti_msg.system_id
                gpb_time = epoc_to_sec(jti_msg.timestamp)
                $log.debug  "Received JTI sensor data from device '#{device_name}' at time '#{gpb_time}'"
                
                # Convert the JTI message into JSON format and parse it with JSON.parse() to convert it to a hash so we can access values.
                # Extract the sensor type and sensor data from the incoming JTI data.
                begin
                    jti_msg_json = JSON.parse(jti_msg.to_json)
                    $log.debug  "Value of 'jti_msg_json': '#{jti_msg_json}'"
                    
                    datas_sensors = jti_msg_json["enterprise"]["juniperNetworks"]
                    $log.debug "Extracted the following sensor data from device '#{device_name}': #{datas_sensors}"
                rescue => e
                    $log.warn "Unable to extract sensor data sensor from jti_msg.enterprise.juniperNetworks, Error during processing: #{$!}"
                    $log.debug "Unable to extract sensor data sensor from jti_msg.enterprise.juniperNetworks, Data Dump : " + jti_msg.inspect.to_s
                    return
                end
                
                
                
                # Iterate over each sensor ...
                # At this point in the code, 'datas_sensors' has the following value:
                #       {"jnpr_interface_ext"=>{"interface_stats"=>[{"if_name"=>"xe-7/2/0", ... }]}}
                # 
                # The ".each" iterator below has the format ".each do |key, value|", which means that
                # 'sensor' is the key, eg. 'jnpr_interface_ext', 'jnpr_qmon_ext', etc. and that
                # 's_data' is the rest of the sensor data, eg. '{"interface_stats"=>[{"if_name"=>"xe-7/2/0", ... }]}'
         
                datas_sensors.each do |sensor, s_data|
                    
                    
                    ############################################################
                    ##  SENSOR:   /junos/services/label-switched-path/usage/  ##
                    ############################################################
                    if sensor == "jnpr_lsp_statistics_ext"
                        
                        resource = "/junos/services/label-switched-path/usage/"
                        $log.debug  "Processing sensor '#{sensor}' with resource '#{resource}'"
                    
                        # At this point in the code, 'data_sensors' has the following value:
=begin
                        NOTE: DATA UNAVAILABLE AT THE TIME OF CODING ... CODE BELOW WRITTEN DIRECTLY FROM VISUAL ANALYSIS OF ASSOCIATED .PROTO FILE
                        TODO: VERIFY THAT THE FOLLOWING CODE WORKS!!
=end
                        # Iterate over each LSP stats record contained within the 'lsp_stats_records' array ...
                        # Note that each LSP's associated data is stored in 'datas'.
                        datas_sensors[sensor]['lsp_stats_records'].each do |datas|
                            
                            # Save all extracted sensor data in a list.
                            sensor_data = []
                            
                            # Block to catch exceptions during sensor data parsing.
                            begin
                               
                                # Add the device name to "sensor_data" for correlation purposes.
                                sensor_data.push({ 'device' => device_name })
                                
                                # According to the LSP_Stats.proto file, each of the child elements under "lsp_stats_records" is going to be a 
                                # "leaf" node (eg. Integer, String, Float, etc.).  These values can be written directly to "sensor_data".
                                datas.each do |level_1_key, level_1_value|
                                    
                                    if level_1_key == "name"
                                        sensor_data.push({ 'lsp_name' => level_1_value })
                                    elsif level_1_key == "instance_identifier"
                                        sensor_data.push({ 'instance_id' => level_1_value })
                                    elsif level_1_key == "counter_name"
                                        sensor_data.push({ 'counter_name' => level_1_value })
                                    else
                                        # By default, InfluxDB assigns the type of a field based on the type of the first value inserted.
                                        # So, in the "value" field, if an Integer is inserted, then the "value" field will only accept Integer
                                        # values hereon after ... so, a String value insertion will result in an error.
                                        # To alleviate this, we will have "value" as the default field for Integers, so as not to break existing code.
                                        # We will add additional "value_string", "value_float", fields to support different value types.  This way,
                                        # we can persist all the various telemetry sensor parameters in InfluxDB, not just the Integer values.
                                        
                                        # Create local copy of 'sensor_data' variable.
                                        local_sensor_data = sensor_data.dup
                                        local_sensor_data = process_value(local_sensor_data, level_1_key, level_1_value, '')
                                        
                                        record = build_record(output_format, local_sensor_data)
                                        ## For debug only ...
                                        #$log.debug  "Value of 'local_sensor_data': '#{local_sensor_data}'"
                                        #$log.debug  "Value of 'record': '#{record}'"
                                        yield gpb_time, record
                                    end
                                end
                               
                            rescue => e
                                $log.warn   "Unable to parse '" + sensor + "' sensor, Error during processing: #{$!}"
                                $log.debug  "Unable to parse '" + sensor + "' sensor, Data Dump: " + datas.inspect.to_s
                            end 
                        end
                    
                    
                    
                    
                    ####################################################
                    ##  SENSOR:   /junos/system/linecard/cpu/memory/  ##
                    ####################################################
                    elsif sensor == "cpu_memory_util_ext"
                    
                        resource = "/junos/system/linecard/cpu/memory/"
                        $log.debug  "Processing sensor '#{sensor}' with resource '#{resource}'"
                    
                        # At this point in the code, 'data_sensors' has the following value:
=begin
                        {
                           "cpu_memory_util_ext": {
                              "utilization": [
                                 {
                                    "name": "Kernel",
                                    "size": 3288330216,
                                    "bytes_allocated": 581290432,
                                    "utilization": 17,
                                    "application_utilization": [
                                       {
                                          "name": "ifd",
                                          "bytes_allocated": 11336,
                                          "allocations": 109,
                                          "frees": 0,
                                          "allocations_failed": 0
                                       },
                                       {
                                          "name": "ifl",
                                          "bytes_allocated": 47832,
                                          "allocations": 115,
                                          "frees": 0,
                                          "allocations_failed": 0
                                       },
                                       ...
                                       {
                                          "name": "inline ka",
                                          "bytes_allocated": 1104,
                                          "allocations": 36,
                                          "frees": 4,
                                          "allocations_failed": 0
                                       }
                                    ]
                                 },
                                 {
                                    "name": "DMA",
                                    "size": 268435456,
                                    "bytes_allocated": 60600272,
                                    "utilization": 22
                                 },
                                 {
                                    "name": "Turbotx",
                                    "size": 21221376,
                                    "bytes_allocated": 368,
                                    "utilization": 1
                                 }
                              ]
                           }
                        }
=end
                        # Iterate over each record contained within the 'utilization' array ...
                        datas_sensors[sensor]['utilization'].each do |datas|
                            
                            # Save all extracted sensor data in a list.
                            sensor_data = []
                            
                            # Block to catch exceptions during sensor data parsing.
                            begin

                                # Add the device name to "sensor_data" for correlation purposes.
                                sensor_data.push({ 'device' => device_name })
                                
                                # Each of the child elements under "utilization" is going to be either a "leaf" node (eg. Integer, String, Float, etc.)
                                # or a "branch" node (eg. Array or Hash), in which case these branch sections need additional level of processing.
                                # For the leaf nodes, these values can be written directly to "sensor_data"
                                
                                datas.each do |level_1_key, level_1_value|

                                    # If the node currently being processed is a "branch node" (ie. it has child nodes)
                                    if level_1_value.is_a?(Hash) || level_1_value.is_a?(Array)
                                        
                                        # From the proto file, we know that the level_1 branch nodes are all Hash values, so we can ignore the conditional
                                        # below testing for an array
                                        if level_1_value.is_a?(Array)
                                            
                                            level_1_value.each do |level_2|
                                            
                                                # Create local copy of 'sensor_data' variable.
                                                local_sensor_data = sensor_data.dup
                                                    
                                                level_2.each do |level_2_key, level_2_value|
                                                    ## For debug only ...
                                                    #$log.debug  "Value of 'level_2_key': '#{level_2_key}'"
                                                    #$log.debug  "Value of 'level_2_value': '#{level_2_value}'"
                                                    
                                                    if level_2_key == "name"
                                                        local_sensor_data.push({ 'cpu_mem_app_name' => level_2_value })
                                                    else
                                                        local_sensor_data = process_value(local_sensor_data, level_2_key, level_2_value, level_1_key)
    
                                                        record = build_record(output_format, local_sensor_data)
                                                        ## For debug only ...
                                                        #$log.debug  "Value of 'local_sensor_data': '#{local_sensor_data}'"
                                                        yield gpb_time, record
                                                    end
                                                end
                                            end
                                            
                                        # If the branch node is not an Array, then we can simply write the key/value pairs straight to "sensor_data".  The exception is 
                                        # "application_utilization", which is an array of "CpuMemoryUtilizationPerApplication", which in turn is a collection of leaf nodes.
                                        else
                                            # Do nothing, as per reasons cited above.
                                        end
                                        
                                    # If the node currently being processed is a "leaf node" (ie. it has NO child nodes)
                                    else
                                        ## For debug only ...
                                        #$log.debug  "Value of 'level_2_key': '#{level_2_key}'"
                                        #$log.debug  "Value of 'level_2_value': '#{level_2_value}'"
                                        
                                        # Create local copy of 'sensor_data' variable.
                                        local_sensor_data = sensor_data.dup
                                        
                                        if level_1_key == "name"
                                            sensor_data.push({ 'cpu_mem_partition_name' => level_1_value })
                                        else
                                            # By default, InfluxDB assigns the type of a field based on the type of the first value inserted.
                                            # So, in the "value" field, if an Integer is inserted, then the "value" field will only accept Integer
                                            # values hereon after ... so, a String value insertion will result in an error.
                                            # To alleviate this, we will have "value" as the default field for Integers, so as not to break existing code.
                                            # We will add additional "value_string", "value_float", fields to support different value types.  This way,
                                            # we can persist all the various telemetry sensor parameters in InfluxDB, not just the Integer values.
                                            
                                            # Create local copy of 'sensor_data' variable.
                                            local_sensor_data = sensor_data.dup
                                            local_sensor_data = process_value(local_sensor_data, level_1_key, level_1_value, '')
                                            
                                            record = build_record(output_format, local_sensor_data)
                                            ## For debug only ...
                                            #$log.debug  "Value of 'local_sensor_data': '#{local_sensor_data}'"
                                            #$log.debug  "Value of 'record': '#{record}'"
                                            yield gpb_time, record
                                        end
                                    end
                                end
                                
                            rescue => e
                                $log.warn   "Unable to parse '" + sensor + "' sensor, Error during processing: #{$!}"
                                $log.debug  "Unable to parse '" + sensor + "' sensor, Data Dump: " + datas.inspect.to_s
                            end
                        end

                    
                    
                    
                    ##################################################
                    ##  SENSOR:   /junos/system/linecard/fabric/  ##
                    ##################################################
                    elsif sensor == "fabricMessageExt"
                    
                        resource = "/junos/system/linecard/fabric/"
                        $log.debug  "Processing sensor '#{sensor}' with resource '#{resource}'"
                        
                        # At this point in the code, 'data_sensors' has the following value:
=begin
                        
=end
                        # Iterate over each record contained within the 'edges' array ...
                        datas_sensors[sensor]['edges'].each do |datas|
                            
                            # Save all extracted sensor data in a list.
                            sensor_data = []
                            
                            # Block to catch exceptions during sensor data parsing.
                            begin
                                
                                
                                
                                
                                
                            rescue => e
                                $log.warn   "Unable to parse '" + sensor + "' sensor, Error during processing: #{$!}"
                                $log.debug  "Unable to parse '" + sensor + "' sensor, Data Dump: " + datas.inspect.to_s
                            end
                        end
                                            
                    
                    
                    
                    
                    ##################################################
                    ##  SENSOR:   /junos/system/linecard/firewall/  ##
                    ##################################################
                    elsif sensor == "jnpr_firewall_ext"
                    
                        resource = "/junos/system/linecard/firewall/"
                        $log.debug  "Processing sensor '#{sensor}' with resource '#{resource}'"
                        
                        # At this point in the code, 'data_sensors' has the following value:
=begin
                        {
                           "jnpr_firewall_ext": {
                              "firewall_stats": [
                                 {
                                    "filter_name": "FILTER1",
                                    "timestamp": 1511326161,
                                    "memory_usage": [
                                       {
                                          "name": "HEAP",
                                          "allocated": 4076
                                       },
                                       ...
                                    ],
                                    "counter_stats": [
                                       {
                                          "name": "COUNTER1",
                                          "packets": 4,
                                          "bytes": 1068
                                       },
                                       ...
                                    ]
                                 },
                                 ...
                              ]
                           }
                        }
=end
                        # Iterate over each firewall filter contained within the 'firewall_stats' array ...
                        # Note that each interface's associated data is stored in 'datas'.
                        datas_sensors[sensor]['firewall_stats'].each do |datas|
                            
                            # Save all extracted sensor data in a list.
                            sensor_data = []
                            
                            # Block to catch exceptions during sensor data parsing.
                            begin
                                
                                # Add the device name to "sensor_data" for correlation purposes.
                                sensor_data.push({ 'device' => device_name })
                                
                                # Each of the child elements under "firewall_stats" is going to be either a "leaf" node (eg. Integer, String, Float, etc.)
                                # or a "branch" node (eg. Array or Hash), in which case these branch sections need additional level of processing.
                                # For the leaf nodes, these values can be written directly to "sensor_data"
                                datas.each do |level_1_key, level_1_value|
                                    
                                    # If the node currently being processed is a "branch node" (ie. it has child nodes)
                                    if level_1_value.is_a?(Hash) || level_1_value.is_a?(Array)
                                        
                                        # From the Firewall.proto file, we know that the level_1 branch nodes are all Array values, ie. "memory_usage",
                                        # "counter_stats", "policer_stats", "hierarchical_policer_stats".
                                        
                                        # We need to treat separately the cases where the branch node is an Array or not.
                                        # If the branch node is an Array, then we must iterate through each element of the Array and then write the key/value
                                        # pairs straight to "sensor_data".
                                        if level_1_value.is_a?(Array)
                                            
                                            # Iterate through each element in the Array ...
                                            level_1_value.each do |level_2|
                                                
                                                # Process the "memory_usage" array separately to avoid adding an unnecessary column to the table.
                                                if level_1_key == "memory_usage"
                                                    # Create local copy of 'sensor_data' variable.
                                                    local_sensor_data = sensor_data.dup  
                                                    local_sensor_data = process_value(local_sensor_data, level_2['name'], level_2['allocated'], level_1_key)
                                                    
                                                    record = build_record(output_format, local_sensor_data)
                                                    ## For debug only ...
                                                    #$log.debug  "Value of 'local_sensor_data': '#{local_sensor_data}'"
                                                    yield gpb_time, record
                                                
                                                # Process the remaining arrays, namely "counter_stats", "policer_stats", "hierarchical_policer_stats".
                                                else

                                                    level_2.each do |level_2_key, level_2_value|
                                                        ## For debug only ...
                                                        #$log.debug  "Value of 'level_2_key': '#{level_2_key}'"
                                                        #$log.debug  "Value of 'level_2_value': '#{level_2_value}'"
                                                        
                                                        # Create local copy of 'sensor_data' variable.
                                                        local_sensor_data = sensor_data.dup                                                        
                                                            
                                                        if level_1_key == "counter_stats"
                                                            local_sensor_data.push({ 'filter_counter_name' => level_2['name'] })
                                                            
                                                        elsif level_1_key == "policer_stats"
                                                            local_sensor_data.push({ 'filter_policer_name' => level_2['name'] })
                                                            
                                                        elsif level_1_key == "hierarchical_policer_stats"
                                                            local_sensor_data.push({ 'filter_hierachical_policer_name' => level_2['name'] })
                                                            
                                                        end
                                                        
                                                        local_sensor_data = process_value(local_sensor_data, level_2_key, level_2_value, level_1_key)
    
                                                        record = build_record(output_format, local_sensor_data)
                                                        ## For debug only ...
                                                        #$log.debug  "Value of 'local_sensor_data': '#{local_sensor_data}'"
                                                        yield gpb_time, record
                                                    end
                                                end
                                            end
                                        
                                        # If the branch node is not an Array, then we can simply write the key/value pairs straight to "sensor_data".
                                        # However, we know from the Firewall.proto file that there are no Hash values at level1.
                                        else                                    
                                            # Do nothing, as per reasons cited above.
                                        end
                                        
                                    # If the node currently being processed is a "leaf node" (ie. it has NO child nodes)
                                    else
                                        
                                        ## For debug only ...    
                                        #$log.debug  "Value of 'level_1_key': '#{level_1_key}'"
                                        #$log.debug  "Value of 'level_1_value': '#{level_1_value}'"
                                        
                                        # We know from the Firewall.proto file that the only two level_1 leaf nodes are "filter_name" and "timestamp"
                                        if level_1_key == "filter_name"
                                            sensor_data.push({ 'filter_name' => level_1_value })
                                        elsif level_1_key == "timestamp"
                                            sensor_data.push({ 'filter_timestamp' => level_1_value })
                                        end
                                    end
                                end
                            
                            rescue => e
                                $log.warn   "Unable to parse '" + sensor + "' sensor, Error during processing: #{$!}"
                                $log.debug  "Unable to parse '" + sensor + "' sensor, Data Dump: " + datas.inspect.to_s
                            end
                        end
                    
                    
                    
                    
                    ###################################################
                    ##  SENSOR:   /junos/system/linecard/interface/  ##
                    ###################################################
                    elsif sensor == "jnpr_interface_ext"
                    
                        resource = "/junos/system/linecard/interface/"
                        $log.debug  "Processing sensor '#{sensor}' with resource '#{resource}'"
                        
                        # At this point in the code, 'datas_sensors' has the following value:
=begin
                        {
                           "jnpr_interface_ext": {
                              "interface_stats": [
                                 {
                                    "if_name": "xe-7/2/0",
                                    "init_time": 1510755828,
                                    "snmp_if_index": 17897,
                                    "egress_queue_info": [
                                       {
                                          "queue_number": 0,
                                          "packets": 0,
                                          "bytes": 0,
                                          "tail_drop_packets": 0,
                                          "rl_drop_packets": 0,
                                          "rl_drop_bytes": 0,
                                          "red_drop_packets": 0,
                                          "red_drop_bytes": 0,
                                          "avg_buffer_occupancy": 0,
                                          "cur_buffer_occupancy": 0,
                                          "peak_buffer_occupancy": 0,
                                          "allocated_buffer_size": 123207680
                                       },
                                       ...
                                       {
                                          "queue_number": 7,
                                          "packets": 0,
                                          "bytes": 0,
                                          "tail_drop_packets": 0,
                                          "rl_drop_packets": 0,
                                          "rl_drop_bytes": 0,
                                          "red_drop_packets": 0,
                                          "red_drop_bytes": 0,
                                          "avg_buffer_occupancy": 0,
                                          "cur_buffer_occupancy": 0,
                                          "peak_buffer_occupancy": 0,
                                          "allocated_buffer_size": 123207680
                                       }
                                    ],
                                    "ingress_stats": {
                                        "if_pkts": 0,
                                        "if_octets": 0,
                                        "if_1sec_pkts": 0,
                                        "if_1sec_octets": 0,
                                        "if_uc_pkts": 0,
                                        "if_mc_pkts": 0,
                                        "if_bc_pkts": 0,
                                        "if_error": 0,
                                        "if_pause_pkts": 0
                                    },
                                    "egress_stats": {
                                        "if_pkts": 0,
                                        "if_octets": 0,
                                        "if_1sec_pkts": 0,
                                        "if_1sec_octets": 0,
                                        "if_uc_pkts": 0,
                                        "if_mc_pkts": 0,
                                        "if_bc_pkts": 0,
                                        "if_error": 0,
                                        "if_pause_pkts": 0
                                    },
                                    "ingress_errors": {
                                        "if_errors": 0,
                                        "if_in_qdrops": 0,
                                        "if_in_frame_errors": 0,
                                        "if_discards": 0,
                                        "if_in_runts": 0,
                                        "if_in_l3_incompletes": 0,
                                        "if_in_l2chan_errors": 0,
                                        "if_in_l2_mismatch_timeouts": 0,
                                        "if_in_fifo_errors": 0,
                                        "if_in_resource_errors": 0
                                    },
                                    "if_operational_status": "UP",
                                    "if_transitions": 1,
                                    "ifLastChange": 0,
                                    "ifHighSpeed": 10000,
                                    "egress_errors": {
                                       "if_errors": 0,
                                       "if_discards": 0
                                    }
                                 },
                                 ...
                              ]
                           }
                        }
=end                     
                        # Iterate over each interface contained within the 'interface_stats' array ...
                        # Note that each interface's associated data is stored in 'datas'.
                        datas_sensors[sensor]['interface_stats'].each do |datas|
                        
                            # Save all extracted sensor data in a list.
                            sensor_data = []
                            
                            # Block to catch exceptions during sensor data parsing.
                            begin
                                
                                # Add the device name to "sensor_data" for correlation purposes.
                                sensor_data.push({ 'device' => device_name })
                                
                                # Each of the child elements under "interface_stats" is going to be either a "leaf" node (eg. Integer, String, Float, etc.)
                                # or a "branch" node (eg. Array or Hash), in which case these branch sections need additional level of processing.
                                # For the leaf nodes, these values can be written directly to "sensor_data"
                                datas.each do |level_1_key, level_1_value|
                                    
                                    # If the node currently being processed is a "branch node" (ie. it has child nodes)
                                    if level_1_value.is_a?(Hash) || level_1_value.is_a?(Array)

                                        # We need to treat separately the cases where the branch node is an Array or not.
                                        # If the branch node is an Array, then we must iterate through each element of the Array and then write the key/value
                                        # pairs straight to "sensor_data".
                                        if level_1_value.is_a?(Array)

                                            # Iterate through each element in the Array ...
                                            level_1_value.each do |level_2|
                                                
                                                level_2.each do |level_2_key, level_2_value|
                                                    ## For debug only ...
                                                    #$log.debug  "Value of 'level_2_key': '#{level_2_key}'"
                                                    #$log.debug  "Value of 'level_2_value': '#{level_2_value}'"
                                                    
                                                    # Create local copy of 'sensor_data' variable.
                                                    local_sensor_data = sensor_data.dup
    
                                                    # According the Port.proto file, QueueStats should be the only type of data that results in an Array branch node 
                                                    # for the /junos/system/linecard/interface/ sensor.  For queue stats, we need to correlate the stats with the 
                                                    # queue number, so we process this separately.  The proto file states that we can have egress or ingress queues.
                                                    if level_1_key == "egress_queue_info"
                                                        local_sensor_data.push({ 'egress_queue' => level_2['queue_number'] })
                                                    elsif level_1_key == "ingress_queue_info"
                                                        local_sensor_data.push({ 'ingress_queue' => level_2['queue_number'] })
                                                    end
                                                    
                                                    local_sensor_data = process_value(local_sensor_data, level_2_key, level_2_value, level_1_key)

                                                    record = build_record(output_format, local_sensor_data)
                                                    ## For debug only ...
                                                    #$log.debug  "Value of 'local_sensor_data': '#{local_sensor_data}'"
                                                    yield gpb_time, record
                                                end
                                            end

                                        # If the branch node is not an Array, then we can simply write the key/value pairs straight to "sensor_data"
                                        else                                    
                                            level_1_value.each do |level_2_key, level_2_value|                                                
                                                ## For debug only ...
                                                #$log.debug  "Value of 'level_2_key': '#{level_2_key}'"
                                                #$log.debug  "Value of 'level_2_value': '#{level_2_value}'"
                                                
                                                # Create local copy of 'sensor_data' variable.
                                                local_sensor_data = sensor_data.dup                                                
                                                local_sensor_data = process_value(local_sensor_data, level_2_key, level_2_value, level_1_key)

                                                record = build_record(output_format, local_sensor_data)
                                                ## For debug only ...
                                                #$log.debug  "Value of 'local_sensor_data': '#{local_sensor_data}'"
                                                yield gpb_time, record
                                            end
                                        end

                                    # If the node currently being processed is a "leaf node" (ie. it has NO child nodes)
                                    else
                                        
                                        ## For debug only ...    
                                        #$log.debug  "Value of 'level_1_key': '#{level_1_key}'"
                                        #$log.debug  "Value of 'level_1_value': '#{level_1_value}'"
                                        
                                        if level_1_key == "if_name"
                                            sensor_data.push({ 'interface' => level_1_value })
                                        elsif level_1_key == "init_time"
                                            # do nothing.
                                        else
                                            # By default, InfluxDB assigns the type of a field based on the type of the first value inserted.
                                            # So, in the "value" field, if an Integer is inserted, then the "value" field will only accept Integer
                                            # values hereon after ... so, a String value insertion will result in an error.
                                            # To alleviate this, we will have "value" as the default field for Integers, so as not to break existing code.
                                            # We will add additional "value_string", "value_float", fields to support different value types.  This way,
                                            # we can persist all the various telemetry sensor parameters in InfluxDB, not just the Integer values.
                                            
                                            # Create local copy of 'sensor_data' variable.
                                            local_sensor_data = sensor_data.dup
                                            local_sensor_data = process_value(local_sensor_data, level_1_key, level_1_value, '')
                                            
                                            record = build_record(output_format, local_sensor_data)
                                            ## For debug only ...
                                            #$log.debug  "Value of 'local_sensor_data': '#{local_sensor_data}'"
                                            #$log.debug  "Value of 'record': '#{record}'"
                                            yield gpb_time, record
                                        end
                                    end
                                end
                                
                            rescue => e
                                $log.warn   "Unable to parse '" + sensor + "' sensor, Error during processing: #{$!}"
                                $log.debug  "Unable to parse '" + sensor + "' sensor, Data Dump: " + datas.inspect.to_s
                            end
                        end    
                    
                    
                    
                    #################################################################
                    ##  SENSOR:   /junos/system/linecard/interface/logical/usage/  ##
                    #################################################################
                    elsif sensor == "jnprLogicalInterfaceExt"
                    
                        resource = "/junos/system/linecard/interface/logical/usage"
                        $log.debug  "Processing sensor '#{sensor}' with resource '#{resource}'"
                    
                        # At this point in the code, 'datas_sensors' has the following value:
=begin
                        {
                           "jnprLogicalInterfaceExt": {
                              "interface_info": [
                                 {
                                    "if_name": "xe-8/0/3:0.0",
                                    "init_time": 1511187519,
                                    "snmp_if_index": 19630,
                                    "ingress_stats": {
                                       "if_packets": 48510,
                                       "if_octets": 10347612,
                                       "if_ucast_packets": 43858,
                                       "if_mcast_packets": 4652
                                    },
                                    "egress_stats": {
                                       "if_packets": 71474,
                                       "if_octets": 89157457,
                                       "if_ucast_packets": 71474,
                                       "if_mcast_packets": 0
                                    },
                                    "op_state": {
                                       "operational_status": "up"
                                    }
                                 },
                                 ...
                              ]
                           }
                        }
=end                     
                        # Iterate over each interface contained within the 'interface_info' array ...
                        # Note that each interface's associated data is stored in 'datas'.
                        datas_sensors[sensor]['interface_info'].each do |datas|
                            
                            # Save all extracted sensor data in a list.
                            sensor_data = []
                            
                            # Block to catch exceptions during sensor data parsing.
                            begin
                                
                                # Add the device name to "sensor_data" for correlation purposes.
                                sensor_data.push({ 'device' => device_name })
                                
                                # Each of the child elements under "queue_monitor_element_info" is going to be either a "leaf" node (eg. Integer, String, Float, etc.)
                                # or a "branch" node (eg. Array or Hash), in which case these branch sections need additional level of processing.
                                # For the leaf nodes, these values can be written directly to "sensor_data"
                                datas.each do |level_1_key, level_1_value|
                                
                                    # If the node currently being processed is a "branch node" (ie. it has child nodes)
                                    if level_1_value.is_a?(Hash) || level_1_value.is_a?(Array)
                                        
                                        # According the Logical_Port.proto file, logicalInterfaceQueueStats should be the only type of data that results in an Array branch node 
                                        # for the /junos/system/linecard/interface/logical/usage sensor.  For queue stats, we need to correlate the stats with the 
                                        # queue number, so we process this separately.  The proto file states that we can have egress or ingress queues.
                                        if level_1_value.is_a?(Array)
                                            
                                            # Iterate through each element in the Array ...
                                            level_1_value.each do |level_2|
                                                
                                                level_2.each do |level_2_key, level_2_value|
                                                    ## For debug only ...
                                                    #$log.debug  "Value of 'level_2_key': '#{level_2_key}'"
                                                    #$log.debug  "Value of 'level_2_value': '#{level_2_value}'"
                                                    
                                                    # Create local copy of 'sensor_data' variable.
                                                    local_sensor_data = sensor_data.dup
    
                                                    if level_1_key == "egress_queue_info"
                                                        local_sensor_data.push({ 'egress_queue' => level_2['queue_number'] })
                                                    elsif level_1_key == "ingress_queue_info"
                                                        local_sensor_data.push({ 'ingress_queue' => level_2['queue_number'] })
                                                    end
                                                    
                                                    local_sensor_data = process_value(local_sensor_data, level_2_key, level_2_value, level_1_key)

                                                    record = build_record(output_format, local_sensor_data)
                                                    ## For debug only ...
                                                    #$log.debug  "Value of 'local_sensor_data': '#{local_sensor_data}'"
                                                    yield gpb_time, record
                                                end
                                            end
                                        
                                        # If the branch node is not an Array, then we can simply write the key/value pairs straight to "sensor_data".  We can do this for 
                                        # "EgressInterfaceStats" and "OperationalState" since these are just collections of leaf nodes.  The exception is "IngressInterfaceStats",
                                        # which contains an array of "ForwardingClassAccounting", which in turn is a collection of leaf nodes.
                                        else
                                            level_1_value.each do |level_2_key, level_2_value|
                                                if level_2_value.is_a?(Array)
                                                    level_2_value.each do |level_3|
                                                        
                                                        level_3.each do |level_3_key, level_3_value|
                                                            ## For debug only ...
                                                            #$log.debug  "Value of 'level_3_key': '#{level_3_key}'"
                                                            #$log.debug  "Value of 'level_3_value': '#{level_3_value}'"
                                                            
                                                            # Create local copy of 'sensor_data' variable.
                                                            local_sensor_data = sensor_data.dup
                                                            
                                                            # For ForwardingClassAccounting stats, we need to correlate the stats with the forwarding class 'fc_number', so we process this separately.
                                                            local_sensor_data.push({ 'family' => level_3['if_family'] })
                                                            local_sensor_data.push({ 'forwarding_class' => level_3['fc_number'] })
                                                            
                                                            local_sensor_data = process_value(local_sensor_data, level_3_key, level_3_value, level_2_key)
        
                                                            record = build_record(output_format, local_sensor_data)
                                                            ## For debug only ...
                                                            #$log.debug  "Value of 'local_sensor_data': '#{local_sensor_data}'"
                                                            yield gpb_time, record
                                                        end
                                                    end
                                                else
                                                    ## For debug only ...
                                                    #$log.debug  "Value of 'level_2_key': '#{level_2_key}'"
                                                    #$log.debug  "Value of 'level_2_value': '#{level_2_value}'"
                                                    
                                                    # Create local copy of 'sensor_data' variable.
                                                    local_sensor_data = sensor_data.dup                                                
                                                    local_sensor_data = process_value(local_sensor_data, level_2_key, level_2_value, level_1_key)
    
                                                    record = build_record(output_format, local_sensor_data)
                                                    ## For debug only ...
                                                    #$log.debug  "Value of 'local_sensor_data': '#{local_sensor_data}'"
                                                    yield gpb_time, record
                                                end
                                            end
                                        end
                                        
                                        
                                    # If the node currently being processed is a "leaf node" (ie. it has NO child nodes)
                                    else
                                        ## For debug only ...    
                                        $log.debug  "Value of 'level_1_key': '#{level_1_key}'"
                                        $log.debug  "Value of 'level_1_value': '#{level_1_value}'"
                                        
                                        if level_1_key == "if_name"
                                            sensor_data.push({ 'interface' => level_1_value })
                                        elsif level_1_key == "init_time"
                                            # do nothing.
                                        else
                                            # By default, InfluxDB assigns the type of a field based on the type of the first value inserted.
                                            # So, in the "value" field, if an Integer is inserted, then the "value" field will only accept Integer
                                            # values hereon after ... so, a String value insertion will result in an error.
                                            # To alleviate this, we will have "value" as the default field for Integers, so as not to break existing code.
                                            # We will add additional "value_string", "value_float", fields to support different value types.  This way,
                                            # we can persist all the various telemetry sensor parameters in InfluxDB, not just the Integer values.
                                            
                                            # Create local copy of 'sensor_data' variable.
                                            local_sensor_data = sensor_data.dup
                                            local_sensor_data = process_value(local_sensor_data, level_1_key, level_1_value, '')
                                            
                                            record = build_record(output_format, local_sensor_data)
                                            ## For debug only ...
                                            #$log.debug  "Value of 'local_sensor_data': '#{local_sensor_data}'"
                                            #$log.debug  "Value of 'record': '#{record}'"
                                            yield gpb_time, record
                                        end
                                    end
                                end
                                
                            rescue => e
                                $log.warn   "Unable to parse '" + sensor + "' sensor, Error during processing: #{$!}"
                                $log.debug  "Unable to parse '" + sensor + "' sensor, Data Dump: " + datas.inspect.to_s
                            end
                            
                        end
                    
                    
                    
                    ##############################################
                    ##  SENSOR:   /junos/system/linecard/qmon/  ##
                    ##############################################
                    elsif sensor == "jnpr_qmon_ext"
                        
                        resource = "/junos/system/linecard/qmon/"
                        $log.debug  "Processing sensor '#{sensor}' with resource '#{resource}'"
                    
                        # At this point in the code, 'datas_sensors' has the following value:
=begin
                           {
                             "jnpr_qmon_ext": {
                                "queue_monitor_element_info": [
                                   {
                                      "if_name": "xe-8/0/0:0",
                                      "queue_monitor_stats_egress": {
                                         "queue_monitor_stats_info": [
                                            {
                                               "queue_number": 0,
                                               "queue_id": 8,
                                               "peak_buffer_occupancy_bytes": 0,
                                               "peak_buffer_occupancy_percent": 0,
                                               "packets": 0,
                                               "octets": 0,
                                               "tail_drop_packets": 0,
                                               "tail_drop_octets": 0,
                                               "red_drop_packets_color_0": 0,
                                               "red_drop_octets_color_0": 0,
                                               "red_drop_packets_color_1": 0,
                                               "red_drop_octets_color_1": 0,
                                               "red_drop_packets_color_2": 0,
                                               "red_drop_octets_color_2": 0,
                                               "red_drop_packets_color_3": 0,
                                               "red_drop_octets_color_3": 0
                                            },
                                            {
                                               "queue_number": 1,
                                               "queue_id": 9,
                                               "peak_buffer_occupancy_bytes": 0,
                                               "peak_buffer_occupancy_percent": 0,
                                               "packets": 0,
                                               "octets": 0,
                                               "tail_drop_packets": 0,
                                               "tail_drop_octets": 0,
                                               "red_drop_packets_color_0": 0,
                                               "red_drop_octets_color_0": 0,
                                               "red_drop_packets_color_1": 0,
                                               "red_drop_octets_color_1": 0,
                                               "red_drop_packets_color_2": 0,
                                               "red_drop_octets_color_2": 0,
                                               "red_drop_packets_color_3": 0,
                                               "red_drop_octets_color_3": 0
                                            },
                                            ...
                                            {
                                               "queue_number": 7,
                                               "queue_id": 15,
                                               "peak_buffer_occupancy_bytes": 0,
                                               "peak_buffer_occupancy_percent": 0,
                                               "packets": 0,
                                               "octets": 0,
                                               "tail_drop_packets": 0,
                                               "tail_drop_octets": 0,
                                               "red_drop_packets_color_0": 0,
                                               "red_drop_octets_color_0": 0,
                                               "red_drop_packets_color_1": 0,
                                               "red_drop_octets_color_1": 0,
                                               "red_drop_packets_color_2": 0,
                                               "red_drop_octets_color_2": 0,
                                               "red_drop_packets_color_3": 0,
                                               "red_drop_octets_color_3": 0
                                            }
                                         ]
                                      }
                                   },
                                   {
                                      "if_name": "xe-8/0/0:1",
                                      "queue_monitor_stats_egress": {
                                         "queue_monitor_stats_info": [
                                            {
                                               "queue_number": 0,
                                               "queue_id": 16,
                                   ...
                                ]
                             }
                          }
                        
=end                     
                        # Iterate over each interface contained within the 'queue_monitor_element_info' array ...
                        # Note that each interface's associated data is stored in 'datas'.
                        datas_sensors[sensor]['queue_monitor_element_info'].each do |datas|
                            
                            # Save all extracted sensor data in a list.
                            sensor_data = []
                            
                            # Block to catch exceptions during sensor data parsing.
                            begin
                                
                                # Add the device name to "sensor_data" for correlation purposes.
                                sensor_data.push({ 'device' => device_name })
                                
                                # Each of the child elements under "queue_monitor_element_info" is going to be either a "leaf" node (eg. Integer, String, Float, etc.)
                                # or a "branch" node (eg. Array or Hash), in which case these branch sections need additional level of processing.
                                # For the leaf nodes, these values can be written directly to "sensor_data"
                                datas.each do |level_1_key, level_1_value|
                                    
                                    # If the node currently being processed is a "branch node" (ie. it has child nodes)
                                    if level_1_value.is_a?(Hash) || level_1_value.is_a?(Array)
                                        
                                        # According the qmon.proto file, the level_1 branch nodes are the Hash elements "queue_monitor_stats_egress" or "queue_monitor_stats_ingress",
                                        # each of which contains an Array called "queue_monitor_stats_info" which is an array of "QueueMonitorStats" instances.
                                        if level_1_value.is_a?(Array)
                                            # Do nothing, for the reasons cited above.
                                        else
                                            # Level_2_key will be either "queue_monitor_stats_egress" or "queue_monitor_stats_ingress", each of which contains an Array of leaf node collections.
                                            level_1_value.each do |level_2_key, level_2_value|
                                                if level_2_value.is_a?(Array)
                                                    ## For debug only ...
                                                    $log.debug  "Value of 'level_2_key': '#{level_2_key}'"
                                                    $log.debug  "Value of 'level_2_value': '#{level_2_value}'"
                                                    
                                                    level_2_value.each do |level_3|
                                                        # 'level_3' will look something like this:
                                                                #{"queue_number"=>6, "queue_id"=>102, "peak_buffer_occupancy_bytes"=>0, "peak_buffer_occupancy_percent"=>0, "packets"=>0, "octets"=>0, "tail_drop_packets"=>0, "tail_drop_octets"=>0, "red_drop_packets_color_0"=>0, "red_drop_octets_color_0"=>0, "red_drop_packets_color_1"=>0, "red_drop_octets_color_1"=>0, "red_drop_packets_color_2"=>0, "red_drop_octets_color_2"=>0, "red_drop_packets_color_3"=>0, "red_drop_octets_color_3"=>0}
                                                        ## For debug only ...
                                                        $log.debug  "Value of 'level_3': '#{level_3}'"
                                                        
                                                        level_3.each do |level_3_key, level_3_value|
                                                            # Debug only
                                                            #$log.debug  "Value of 'level_3_key': '#{level_3_key}'"
                                                            #$log.debug  "Value of 'level_3_value': '#{level_3_value}'"
                                                            
                                                            # Create local copy of 'sensor_data' variable.
                                                            local_sensor_data = sensor_data.dup
            
                                                            # For queue stats, we need to correlate the stats with the queue number, so we process this separately.
                                                            # The proto file states that we can have egress or ingress queues.
                                                            if level_1_key == "queue_monitor_stats_egress"
                                                                local_sensor_data.push({ 'egress_queue' => level_3['queue_number'] })
                                                            elsif level_1_key == "queue_monitor_stats_ingress"
                                                                local_sensor_data.push({ 'ingress_queue' => level_3['queue_number'] })
                                                            end
                                                            
                                                            local_sensor_data = process_value(local_sensor_data, level_3_key, level_3_value, level_2_key)
        
                                                            record = build_record(output_format, local_sensor_data)
                                                            ## For debug only ...
                                                            #$log.debug  "Value of 'local_sensor_data': '#{local_sensor_data}'"
                                                            yield gpb_time, record 
                                                        end
                                                    end
                                                else
                                                    # Do nothing, as per reasons cited above.
                                                end
                                            end
                                        end
                                    
                                    # If the node currently being processed is a "leaf node" (ie. it has NO child nodes)
                                    else
                                        ## For debug only ...    
                                        #$log.debug  "Value of 'level_1_key': '#{level_1_key}'"
                                        #$log.debug  "Value of 'level_1_value': '#{level_1_value}'"
                                        
                                        if level_1_key == "if_name"
                                            sensor_data.push({ 'interface' => level_1_value })
                                        elsif level_1_key == "init_time"
                                            # do nothing.
                                        else
                                            # By default, InfluxDB assigns the type of a field based on the type of the first value inserted.
                                            # So, in the "value" field, if an Integer is inserted, then the "value" field will only accept Integer
                                            # values hereon after ... so, a String value insertion will result in an error.
                                            # To alleviate this, we will have "value" as the default field for Integers, so as not to break existing code.
                                            # We will add additional "value_string", "value_float", fields to support different value types.  This way,
                                            # we can persist all the various telemetry sensor parameters in InfluxDB, not just the Integer values.
                                            
                                            # Create local copy of 'sensor_data' variable.
                                            local_sensor_data = sensor_data.dup
                                            local_sensor_data = process_value(local_sensor_data, level_1_key, level_1_value, '')
                                            
                                            record = build_record(output_format, local_sensor_data)
                                            ## For debug only ...
                                            #$log.debug  "Value of 'local_sensor_data': '#{local_sensor_data}'"
                                            #$log.debug  "Value of 'record': '#{record}'"
                                            yield gpb_time, record
                                        end
                                    end
                                end
                                
                            rescue => e
                                $log.warn   "Unable to parse '" + sensor + "' sensor, Error during processing: #{$!}"
                                $log.debug  "Unable to parse '" + sensor + "' sensor, Data Dump: " + datas.inspect.to_s
                            end
                            
                        end
                    
                    
                    
                    end
                end
            end
            
            
            
            def process_value(local_sensor_data, key, value, parent_key)
                
                if value.is_a?(Integer)
                    if parent_key == ''
                        local_sensor_data.push({ 'type' => key })
                    elsif
                        local_sensor_data.push({ 'type' => parent_key + '.' + key })
                    end
                    local_sensor_data.push({ 'value' => value })
                    local_sensor_data.push({ 'value_string' => '' })
                    local_sensor_data.push({ 'value_float' => -0.0 })
                    
                elsif value.is_a?(String)
                    if parent_key == ''
                        local_sensor_data.push({ 'type' => key })
                    elsif
                        local_sensor_data.push({ 'type' => parent_key + '.' + key })
                    end
                    local_sensor_data.push({ 'value' => -1 })
                    local_sensor_data.push({ 'value_string' => value })
                    local_sensor_data.push({ 'value_float' => -0.0 })
                    
                elsif value.is_a?(Float)
                    if parent_key == ''
                        local_sensor_data.push({ 'type' => key })
                    elsif
                        local_sensor_data.push({ 'type' => parent_key + '.' + key })
                    end
                    local_sensor_data.push({ 'value' => -1 })
                    local_sensor_data.push({ 'value_string' => '' })
                    local_sensor_data.push({ 'value_float' => value })
                end
                
                return local_sensor_data
            end
            

        end
    end
end
