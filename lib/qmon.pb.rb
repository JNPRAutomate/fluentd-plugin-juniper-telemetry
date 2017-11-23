# encoding: utf-8

##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf'


##
# Imports
#
require 'pbj.pb'
require 'telemetry_top.pb'


##
# Message Classes
#
class QueueMonitor < ::Protobuf::Message; end
class QueueMonitorElement < ::Protobuf::Message; end
class QueueMonitorDirection < ::Protobuf::Message; end
class QueueMonitorStats < ::Protobuf::Message; end


##
# Message Fields
#
class QueueMonitor
  repeated ::QueueMonitorElement, :queue_monitor_element_info, 1, :".pbj_field_option" => { :max_count => 2048 }
end

class QueueMonitorElement
  required :string, :if_name, 1, :".pbj_field_option" => { :type => ::FieldType::FT_POINTER }, :".telemetry_options" => { :is_key => true }
  optional :string, :parent_ae_name, 2, :".pbj_field_option" => { :type => ::FieldType::FT_POINTER }
  optional ::QueueMonitorDirection, :queue_monitor_stats_ingress, 3
  optional ::QueueMonitorDirection, :queue_monitor_stats_egress, 4
end

class QueueMonitorDirection
  repeated ::QueueMonitorStats, :queue_monitor_stats_info, 1, :".pbj_field_option" => { :max_count => 8 }
end

class QueueMonitorStats
  required :uint32, :queue_number, 1, :".telemetry_options" => { :is_key => true }
  required :uint32, :queue_id, 2, :".telemetry_options" => { :is_key => true }
  required :uint32, :peak_buffer_occupancy_bytes, 3, :".telemetry_options" => { :is_gauge => true }
  optional :uint32, :peak_buffer_occupancy_percent, 4, :".telemetry_options" => { :is_gauge => true }
  required :uint64, :packets, 5, :".telemetry_options" => { :is_counter => true }
  required :uint64, :octets, 6, :".telemetry_options" => { :is_counter => true }
  required :uint64, :tail_drop_packets, 7, :".telemetry_options" => { :is_counter => true }
  required :uint64, :tail_drop_octets, 8, :".telemetry_options" => { :is_counter => true }
  required :uint64, :red_drop_packets_color_0, 9, :".telemetry_options" => { :is_counter => true }
  required :uint64, :red_drop_octets_color_0, 10, :".telemetry_options" => { :is_counter => true }
  required :uint64, :red_drop_packets_color_1, 11, :".telemetry_options" => { :is_counter => true }
  required :uint64, :red_drop_octets_color_1, 12, :".telemetry_options" => { :is_counter => true }
  required :uint64, :red_drop_packets_color_2, 13, :".telemetry_options" => { :is_counter => true }
  required :uint64, :red_drop_octets_color_2, 14, :".telemetry_options" => { :is_counter => true }
  required :uint64, :red_drop_packets_color_3, 15, :".telemetry_options" => { :is_counter => true }
  required :uint64, :red_drop_octets_color_3, 16, :".telemetry_options" => { :is_counter => true }
end


##
# Extended Message Fields
#
class ::JuniperNetworksSensors < ::Protobuf::Message
  optional ::QueueMonitor, :".jnpr_qmon_ext", 15, :extension => true
end

