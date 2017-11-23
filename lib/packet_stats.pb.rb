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
class PacketStatistics < ::Protobuf::Message; end
class PacketStatsPacketForwardingEngine < ::Protobuf::Message; end
class PacketStatsClass < ::Protobuf::Message; end
class PacketStatsCounter < ::Protobuf::Message; end


##
# Message Fields
#
class PacketStatistics
  repeated ::PacketStatsClass, :packet_stats, 1
  repeated ::PacketStatsPacketForwardingEngine, :packet_stats_pfe, 2
end

class PacketStatsPacketForwardingEngine
  required :string, :pfe_identifier, 1
  repeated ::PacketStatsClass, :packet_stats, 2
end

class PacketStatsClass
  required :string, :name, 1
  required ::PacketStatsCounter, :counter, 2
end

class PacketStatsCounter
  required :uint64, :packet_count, 1
  optional :uint64, :byte_count, 2
  optional :uint64, :packet_rate, 3
  optional :uint64, :bit_rate, 4
end


##
# Extended Message Fields
#
class ::JuniperNetworksSensors < ::Protobuf::Message
  optional ::PacketStatistics, :".jnpr_packet_statistics_ext", 8, :extension => true
end

