# encoding: utf-8

##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf'


##
# Imports
#
require 'telemetry_top.pb'


##
# Message Classes
#
class Fabric_message < ::Protobuf::Message
  class Sensor_location < ::Protobuf::Enum
    define :Linecard, 1
    define :Switch_Fabric, 2
  end

end

class Edge_stats < ::Protobuf::Message
  class Identifier_type < ::Protobuf::Enum
    define :Switch_Fabric, 1
    define :Linecard, 2
  end

end

class Class_stats < ::Protobuf::Message; end
class Counters < ::Protobuf::Message; end


##
# Message Fields
#
class Fabric_message
  repeated ::Edge_stats, :edges, 1
  optional ::Fabric_message::Sensor_location, :location, 2, :".telemetry_options" => { :is_key => true }
end

class Edge_stats
  optional ::Edge_stats::Identifier_type, :source_type, 1, :".telemetry_options" => { :is_key => true }
  optional :uint32, :source_slot, 2, :".telemetry_options" => { :is_key => true }
  optional :uint32, :source_pfe, 3, :".telemetry_options" => { :is_key => true }
  optional ::Edge_stats::Identifier_type, :destination_type, 4, :".telemetry_options" => { :is_key => true }
  optional :uint32, :destination_slot, 5, :".telemetry_options" => { :is_key => true }
  optional :uint32, :destination_pfe, 6, :".telemetry_options" => { :is_key => true }
  repeated ::Class_stats, :class_stats, 7
end

class Class_stats
  optional :string, :priority, 1, :".telemetry_options" => { :is_key => true }
  optional ::Counters, :transmit_counts, 2
end

class Counters
  optional :uint64, :packets, 1, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :bytes, 2, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :packets_per_second, 3, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :bytes_per_second, 4, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :drop_packets, 5, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :drop_bytes, 6, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :drop_packets_per_second, 7, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :drop_bytes_per_second, 8, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :queue_depth_average, 9, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :queue_depth_current, 10, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :queue_depth_peak, 11, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :queue_depth_maximum, 12, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :error_packets, 13, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :error_packets_per_second, 14, :".telemetry_options" => { :is_gauge => true }
end


##
# Extended Message Fields
#
class ::JuniperNetworksSensors < ::Protobuf::Message
  optional ::Fabric_message, :".fabricMessageExt", 2, :extension => true
end

