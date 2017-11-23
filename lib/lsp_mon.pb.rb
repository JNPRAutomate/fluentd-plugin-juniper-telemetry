# encoding: utf-8

##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf'


##
# Enum Classes
#
class Lsp_event < ::Protobuf::Enum
  define :INITIATED, 0
  define :CONCLUDED_UP, 1
  define :CONCLUDED_TORN_DOWN, 2
  define :PROTECTION_AVAILABLE, 3
  define :PROTECTION_UNAVAILABLE, 4
  define :AUTOBW_SUCCESS, 5
  define :AUTOBW_FAIL, 6
  define :RESV_TEAR_RECEIVED, 7
  define :DESELECT_ACTIVE_PATH, 8
  define :CHANGE_ACTIVE_PATH, 9
  define :DETOUR_UP, 10
  define :DETOUR_DOWN, 11
  define :ORIGINATE_MBB, 12
  define :SELECT_ACTIVE_PATH, 13
  define :CSPF_NO_ROUTE, 14
  define :CSPF_SUCCESS, 15
  define :RESTART_RECOVERY_FAIL, 16
  define :PATHERR_RECEIVED, 17
  define :PATH_MTU_CHANGE, 18
  define :TUNNEL_LOCAL_REPAIRED, 19
end

class Event_subcode < ::Protobuf::Enum
  define :ADMISSION_CONTROL_FAILURE, 1
  define :SESSION_PREEMPTED, 2
  define :BAD_LOOSE_ROUTE, 3
  define :BAD_STRICT_ROUTE, 4
  define :LABEL_ALLOCATION_FAILURE, 5
  define :NON_RSVP_CAPABLE_ROUTER, 6
  define :TTL_EXPIRED, 7
  define :ROUTING_LOOP_DETECTED, 8
  define :REQUESTED_BANDWIDTH_UNAVAILABLE, 9
end


##
# Message Classes
#
class Key < ::Protobuf::Message; end
class Lsp_monitor_data_event < ::Protobuf::Message; end
class Ero_type_entry < ::Protobuf::Message; end
class Ero_ipv4_type < ::Protobuf::Message; end
class Rro_type_entry < ::Protobuf::Message; end
class Rro_ipv4_type < ::Protobuf::Message; end
class Lsp_monitor_data_property < ::Protobuf::Message; end
class Lsp_mon < ::Protobuf::Message; end


##
# File Options
#
#set_option :optimize_for, ::Google::Protobuf::FileOptions::OptimizeMode::LITE_RUNTIME


##
# Message Fields
#
class Key
  required :string, :name, 1
  required :int32, :instance_identifier, 2
  required :uint64, :time_stampg, 3
end

class Lsp_monitor_data_event
  required ::Lsp_event, :event_identifier, 1
  optional ::Event_subcode, :subcode, 2
end

class Ero_type_entry
  required :uint32, :ip, 1
  optional :string, :flags, 2
end

class Ero_ipv4_type
  repeated ::Ero_type_entry, :entry, 1
end

class Rro_type_entry
  optional :uint32, :nodeid, 1
  optional :uint32, :flags, 2
  optional :uint32, :intf_addr, 3
  optional :uint32, :label, 4
end

class Rro_ipv4_type
  repeated ::Rro_type_entry, :rro_entry, 1
end

class Lsp_monitor_data_property
  optional :uint64, :bandwidth, 1
  optional :string, :path_name, 2
  optional :int32, :metric, 3
  optional :float, :max_avg_bw, 4
  optional ::Ero_ipv4_type, :ero, 5
  optional ::Rro_ipv4_type, :rro, 6
end

class Lsp_mon
  required ::Key, :key_field, 1
  optional ::Lsp_monitor_data_event, :event_field, 2
  optional ::Lsp_monitor_data_property, :property_field, 3
end

