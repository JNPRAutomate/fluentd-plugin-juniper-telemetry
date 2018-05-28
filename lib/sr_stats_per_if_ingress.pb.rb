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
class SrStatsPerIfIngress < ::Protobuf::Message; end
class SegmentRoutingIngIfRecord < ::Protobuf::Message; end
class SegmentRoutingIngIfStats < ::Protobuf::Message; end


##
# Message Fields
#
class SrStatsPerIfIngress
  repeated ::SegmentRoutingIngIfRecord, :per_if_records, 1
end

class SegmentRoutingIngIfRecord
  required :string, :if_name, 1, :".telemetry_options" => { :is_key => true }
  optional :string, :parent_ae_name, 2, :".telemetry_options" => { :is_key => true }
  optional :string, :counter_name, 3, :".telemetry_options" => { :is_key => true }
  optional ::SegmentRoutingIngIfStats, :ingress_stats, 4
  optional ::SegmentRoutingIngIfStats, :egress_stats, 5
end

class SegmentRoutingIngIfStats
  optional :uint64, :packets, 1, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :bytes, 2, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :packet_rate, 3, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :byte_rate, 4, :".telemetry_options" => { :is_gauge => true }
end


##
# Extended Message Fields
#
class ::JuniperNetworksSensors < ::Protobuf::Message
  optional ::SrStatsPerIfIngress, :".jnpr_sr_stats_per_if_ingress_ext", 19, :extension => true
end

