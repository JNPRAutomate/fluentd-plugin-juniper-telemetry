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
class InlineJflow < ::Protobuf::Message; end
class InlineJflowNpuStats < ::Protobuf::Message; end


##
# Message Fields
#
class InlineJflow
  optional :string, :ipv4_flows_export_format, 2
  optional :string, :ipv6_flows_export_format, 3
  optional :string, :vpls_flows_export_format, 4
  optional :string, :mpls_flows_export_format, 5
  optional :uint32, :ipv4_route_record_cnt, 6
  optional :uint32, :ipv6_route_record_cnt, 7
  optional :uint32, :mpls_route_record_cnt, 8
  optional :uint32, :autonomous_system_record_cnt, 9
  optional :uint64, :ipv4_max_flows_count, 10
  optional :uint64, :ipv6_max_flows_count, 11
  optional :uint64, :vpls_max_flows_count, 12
  optional :uint64, :mpls_max_flows_count, 13
  optional :uint32, :memory_alloc_fail_cnt, 14, :".telemetry_options" => { :is_counter => true }
  optional :uint32, :ipv4_configured_observation_domain_id, 15
  optional :uint32, :ipv6_configured_observation_domain_id, 16
  optional :uint32, :vpls_configured_observation_domain_id, 17
  optional :uint32, :mpls_configured_observation_domain_id, 18
  optional :uint32, :last_clear_timestamp, 19
  optional :bool, :ipv6_extended_attribute, 20
  optional :bool, :flexible_flow_sizing, 21
  optional :bool, :use_extended_flow_memory, 22
  repeated ::InlineJflowNpuStats, :npu_stats, 50
end

class InlineJflowNpuStats
  required :uint32, :npu_identifier, 1
  optional :uint64, :ipv4_flow_packets, 51, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv4_flow_bytes, 52, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv4_total_flows, 53, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv4_active_flows, 54, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv4_flows_exported, 55, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv4_packets_exported, 56, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv4_flows_inactive_timed_out, 57, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv4_flows_active_timed_out, 58, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv4_flow_create_failure, 59, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv4_route_lookup_failure, 60, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv4_autonomous_system_lookup_failure, 61, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv4_flow_packet_export_failure, 62, :".telemetry_options" => { :is_counter => true }
  optional :float, :ipv4_flow_table_utilization, 63, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :ipv4_flow_insert_count, 64, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv6_flow_packets, 101, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv6_flow_bytes, 102, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv6_total_flows, 103, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv6_active_flows, 104, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv6_flows_exported, 105, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv6_packets_exported, 106, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv6_flows_inactive_timed_out, 107, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv6_flows_active_timed_out, 108, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv6_flow_create_failure, 109, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv6_route_lookup_failure, 110, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv6_autonomous_system_lookup_failure, 111, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :ipv6_flow_packet_export_failure, 112, :".telemetry_options" => { :is_counter => true }
  optional :float, :ipv6_flow_table_utilization, 113, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :ipv6_flow_insert_count, 114, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :vpls_flow_packets, 151, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :vpls_flow_bytes, 152, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :vpls_total_flows, 153, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :vpls_active_flows, 154, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :vpls_flows_exported, 155, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :vpls_packets_exported, 156, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :vpls_flows_inactive_timed_out, 157, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :vpls_flows_active_timed_out, 158, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :vpls_flow_create_failure, 159, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :vpls_route_lookup_failure, 160, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :vpls_autonomous_system_lookup_failure, 161, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :vpls_flow_packet_export_failure, 162, :".telemetry_options" => { :is_counter => true }
  optional :float, :vpls_flow_table_utilization, 163, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :vpls_flow_insert_count, 164, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :mpls_flow_packets, 201, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :mpls_flow_bytes, 202, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :mpls_total_flows, 203, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :mpls_active_flows, 204, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :mpls_flows_exported, 205, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :mpls_packets_exported, 206, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :mpls_flows_inactive_timed_out, 207, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :mpls_flows_active_timed_out, 208, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :mpls_flow_create_failure, 209, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :mpls_route_lookup_failure, 210, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :mpls_autonomous_system_lookup_failure, 211, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :mpls_flow_packet_export_failure, 212, :".telemetry_options" => { :is_counter => true }
  optional :float, :mpls_flow_table_utilization, 213, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :mpls_flow_insert_count, 214, :".telemetry_options" => { :is_counter => true }
end


##
# Extended Message Fields
#
class ::JuniperNetworksSensors < ::Protobuf::Message
  optional ::InlineJflow, :".inline_jflow_stats_ext", 9, :extension => true
end

