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
class SrStatsPerIfEgress < ::Protobuf::Message; end
class SegmentRoutingInterfaceRecord < ::Protobuf::Message; end
class SegmentRoutingIfStats < ::Protobuf::Message; end


##
# Message Fields
#
class SrStatsPerIfEgress
  repeated ::SegmentRoutingInterfaceRecord, :per_if_records, 1
end

class SegmentRoutingInterfaceRecord
  required :string, :if_name, 1, :".telemetry_options" => { :is_key => true }
  optional :string, :parent_ae_name, 2, :".telemetry_options" => { :is_key => true }
  optional :string, :counter_name, 3, :".telemetry_options" => { :is_key => true }
  optional ::SegmentRoutingIfStats, :ingress_stats, 4
  optional ::SegmentRoutingIfStats, :egress_stats, 5
end

class SegmentRoutingIfStats
  optional :uint64, :packets, 1, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :bytes, 2, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :packet_rate, 3, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :byte_rate, 4, :".telemetry_options" => { :is_gauge => true }
end


##
# Extended Message Fields
#
class ::JuniperNetworksSensors < ::Protobuf::Message
  optional ::SrStatsPerIfEgress, :".jnpr_sr_stats_per_if_egress_ext", 17, :extension => true
end

