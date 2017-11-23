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
class LspStats < ::Protobuf::Message; end
class LspStatsRecord < ::Protobuf::Message; end


##
# Message Fields
#
class LspStats
  repeated ::LspStatsRecord, :lsp_stats_records, 1
end

class LspStatsRecord
  required :string, :name, 1, :".telemetry_options" => { :is_key => true }
  required :uint32, :instance_identifier, 2, :".telemetry_options" => { :is_key => true }
  required :string, :counter_name, 3, :".telemetry_options" => { :is_key => true }
  optional :uint64, :packets, 4, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :bytes, 5, :".telemetry_options" => { :is_counter => true }
  optional :uint64, :packet_rate, 6
  optional :uint64, :byte_rate, 7
end


##
# Extended Message Fields
#
class ::JuniperNetworksSensors < ::Protobuf::Message
  optional ::LspStats, :".jnpr_lsp_statistics_ext", 5, :extension => true
end

