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
class NetworkProcessorMemoryUtilization < ::Protobuf::Message; end
class NpuMemory < ::Protobuf::Message; end
class NpuMemorySummary < ::Protobuf::Message; end
class NpuMemoryPartition < ::Protobuf::Message; end


##
# Message Fields
#
class NetworkProcessorMemoryUtilization
  repeated ::NpuMemory, :memory_stats, 1
end

class NpuMemory
  required :string, :identifier, 1
  repeated ::NpuMemorySummary, :summary, 2
  repeated ::NpuMemoryPartition, :partition, 3
end

class NpuMemorySummary
  optional :string, :resource_name, 1
  optional :uint64, :size, 2
  optional :uint64, :allocated, 3
  optional :int32, :utilization, 4
end

class NpuMemoryPartition
  optional :string, :name, 1
  optional :string, :application_name, 2
  optional :uint32, :bytes_allocated, 3
  optional :uint32, :allocation_count, 4
  optional :uint32, :free_count, 5
end


##
# Extended Message Fields
#
class ::JuniperNetworksSensors < ::Protobuf::Message
  optional ::NetworkProcessorMemoryUtilization, :".npu_memory_ext", 11, :extension => true
end

