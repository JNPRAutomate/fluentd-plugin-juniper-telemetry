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
class NetworkProcessorUtilization < ::Protobuf::Message; end
class Utilization < ::Protobuf::Message; end
class MemoryLoad < ::Protobuf::Message; end
class PacketLoad < ::Protobuf::Message; end


##
# Message Fields
#
class NetworkProcessorUtilization
  repeated ::Utilization, :npu_util_stats, 1
end

class Utilization
  required :string, :identifier, 1
  optional :uint32, :utilization, 2
  repeated ::PacketLoad, :packets, 3
  repeated ::MemoryLoad, :memory, 4
end

class MemoryLoad
  optional :string, :name, 1
  optional :uint32, :average_util, 2
  optional :uint32, :highest_util, 3
  optional :uint32, :lowest_util, 4
  optional :uint32, :average_cache_hit_rate, 5
  optional :uint32, :highest_cache_hit_rate, 6
  optional :uint32, :lowest_cache_hit_rate, 7
end

class PacketLoad
  required :string, :identifier, 1
  optional :uint64, :rate, 2
  optional :uint32, :average_instructions_per_packet, 3
  optional :uint32, :average_wait_cycles_per_packet, 4
  optional :uint32, :average_cycles_per_packet, 5
end


##
# Extended Message Fields
#
class ::JuniperNetworksSensors < ::Protobuf::Message
  optional ::NetworkProcessorUtilization, :".jnpr_npu_utilization_ext", 12, :extension => true
end

