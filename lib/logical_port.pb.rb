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
class LogicalPort < ::Protobuf::Message; end
class LogicalInterfaceInfo < ::Protobuf::Message; end
class IngressInterfaceStats < ::Protobuf::Message; end
class EgressInterfaceStats < ::Protobuf::Message; end
class OperationalState < ::Protobuf::Message; end
class ForwardingClassAccounting < ::Protobuf::Message; end
class LogicalInterfaceQueueStats < ::Protobuf::Message; end


##
# Message Fields
#
class LogicalPort
  repeated ::LogicalInterfaceInfo, :interface_info, 1
end

class LogicalInterfaceInfo
  required :string, :if_name, 1, :".telemetry_options" => { :is_key => true }
  required :uint64, :init_time, 2, :".telemetry_options" => { :is_timestamp => true }
  optional :uint32, :snmp_if_index, 3, :".telemetry_options" => { :is_key => true }
  optional :string, :parent_ae_name, 4, :".telemetry_options" => { :is_key => true }
  optional ::IngressInterfaceStats, :ingress_stats, 5
  optional ::EgressInterfaceStats, :egress_stats, 6
  optional ::OperationalState, :op_state, 7
  optional :string, :administractive_status, 8
  optional :string, :description, 9
  optional :uint32, :last_change, 10
  optional :uint32, :high_speed, 11
  repeated ::LogicalInterfaceQueueStats, :ingress_queue_info, 12
  repeated ::LogicalInterfaceQueueStats, :egress_queue_info, 13
end

class IngressInterfaceStats
  required :uint64, :if_packets, 1, :".telemetry_options" => { :is_counter => true }
  required :uint64, :if_octets, 2, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_ucast_packets, 3, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_mcast_packets, 4, :".telemetry_options" => { :is_counter => true }
  repeated ::ForwardingClassAccounting, :if_fc_stats, 5
end

class EgressInterfaceStats
  required :uint64, :if_packets, 1, :".telemetry_options" => { :is_counter => true }
  required :uint64, :if_octets, 2, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_ucast_packets, 3, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_mcast_packets, 4, :".telemetry_options" => { :is_counter => true }
end

class OperationalState
  optional :string, :operational_status, 1
end

class ForwardingClassAccounting
  optional :string, :if_family, 1, :".telemetry_options" => { :is_key => true }
  optional :uint32, :fc_number, 2, :".telemetry_options" => { :is_key => true }
  optional :uint64, :if_packets, 3, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_octets, 4, :".telemetry_options" => { :is_counter => true }
end

class LogicalInterfaceQueueStats
  optional :uint32, :queue_number, 1, :".telemetry_options" => { :is_key => true }
  optional :uint64, :packets, 2, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :bytes, 3, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :tail_drop_packets, 4, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :rate_limit_drop_packets, 5, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :rate_limit_drop_bytes, 6, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :red_drop_packets, 7, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :red_drop_bytes, 8, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :average_buffer_occupancy, 9, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :current_buffer_occupancy, 10, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :peak_buffer_occupancy, 11, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :allocated_buffer_size, 12, :".telemetry_options" => { :is_gauge => true }
end


##
# Extended Message Fields
#
class ::JuniperNetworksSensors < ::Protobuf::Message
  optional ::LogicalPort, :".jnprLogicalInterfaceExt", 7, :extension => true
end

