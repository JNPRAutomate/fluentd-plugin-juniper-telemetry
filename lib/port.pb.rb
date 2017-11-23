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
class Port < ::Protobuf::Message; end
class InterfaceInfos < ::Protobuf::Message; end
class QueueStats < ::Protobuf::Message; end
class InterfaceStats < ::Protobuf::Message; end
class IngressInterfaceErrors < ::Protobuf::Message; end
class EgressInterfaceErrors < ::Protobuf::Message; end


##
# Message Fields
#
class Port
  repeated ::InterfaceInfos, :interface_stats, 1
end

class InterfaceInfos
  required :string, :if_name, 1, :".telemetry_options" => { :is_key => true }
  optional :uint64, :init_time, 2
  optional :uint32, :snmp_if_index, 3
  optional :string, :parent_ae_name, 4
  repeated ::QueueStats, :egress_queue_info, 5
  repeated ::QueueStats, :ingress_queue_info, 6
  optional ::InterfaceStats, :ingress_stats, 7
  optional ::InterfaceStats, :egress_stats, 8
  optional ::IngressInterfaceErrors, :ingress_errors, 9
  optional :string, :if_administration_status, 10
  optional :string, :if_operational_status, 11
  optional :string, :if_description, 12
  optional :uint64, :if_transitions, 13, :".telemetry_options" => { :is_counter => true }
  optional :uint32, :ifLastChange, 14
  optional :uint32, :ifHighSpeed, 15
  optional ::EgressInterfaceErrors, :egress_errors, 16
end

class QueueStats
  optional :uint32, :queue_number, 1, :".telemetry_options" => { :is_key => true }
  optional :uint64, :packets, 2, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :bytes, 3, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :tail_drop_packets, 4, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :rl_drop_packets, 5, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :rl_drop_bytes, 6, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :red_drop_packets, 7, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :red_drop_bytes, 8, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :avg_buffer_occupancy, 9, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :cur_buffer_occupancy, 10, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :peak_buffer_occupancy, 11, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :allocated_buffer_size, 12, :".telemetry_options" => { :is_gauge => true }
end

class InterfaceStats
  optional :uint64, :if_pkts, 1, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_octets, 2, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_1sec_pkts, 3, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :if_1sec_octets, 4, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :if_uc_pkts, 5, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_mc_pkts, 6, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_bc_pkts, 7, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_error, 8, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_pause_pkts, 9, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_unknown_proto_pkts, 10, :".telemetry_options" => { :is_counter => true }
end

class IngressInterfaceErrors
  optional :uint64, :if_errors, 1, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_in_qdrops, 2, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_in_frame_errors, 3, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_discards, 4, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_in_runts, 5, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_in_l3_incompletes, 6, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_in_l2chan_errors, 7, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_in_l2_mismatch_timeouts, 8, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_in_fifo_errors, 9, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_in_resource_errors, 10, :".telemetry_options" => { :is_counter => true }
end

class EgressInterfaceErrors
  optional :uint64, :if_errors, 1, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :if_discards, 2, :".telemetry_options" => { :is_counter => true }
end


##
# Extended Message Fields
#
class ::JuniperNetworksSensors < ::Protobuf::Message
  optional ::Port, :".jnpr_interface_ext", 3, :extension => true
end

