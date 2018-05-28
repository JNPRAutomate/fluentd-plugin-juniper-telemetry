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
class SrStatsPerSid < ::Protobuf::Message; end
class SegmentRoutingRecord < ::Protobuf::Message; end
class SegmentRoutingStats < ::Protobuf::Message; end


##
# Message Fields
#
class SrStatsPerSid
  repeated ::SegmentRoutingRecord, :sid_stats, 1
end

class SegmentRoutingRecord
  required :string, :sid_identifier, 1, :".telemetry_options" => { :is_key => true }
  optional :uint32, :instance_identifier, 2, :".telemetry_options" => { :is_key => true }
  required :string, :counter_name, 3, :".telemetry_options" => { :is_key => true }
  optional ::SegmentRoutingStats, :ingress_stats, 4
  optional ::SegmentRoutingStats, :egress_stats, 5
end

class SegmentRoutingStats
  optional :uint64, :packets, 1, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :bytes, 2, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :packet_rate, 3, :".telemetry_options" => { :is_gauge => true }
  optional :uint64, :byte_rate, 4, :".telemetry_options" => { :is_gauge => true }
end


##
# Extended Message Fields
#
class ::JuniperNetworksSensors < ::Protobuf::Message
  optional ::SrStatsPerSid, :".jnpr_sr_stats_per_sid_ext", 16, :extension => true
end

