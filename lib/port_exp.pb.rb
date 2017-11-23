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
class Port_exp < ::Protobuf::Message; end
class InterfaceExpInfos < ::Protobuf::Message; end


##
# Message Fields
#
class Port_exp
  repeated ::InterfaceExpInfos, :interfaceExp_stats, 1
end

class InterfaceExpInfos
  required :string, :if_name, 1, :".telemetry_options" => { :is_key => true }
  optional :string, :if_operational_status, 2
end


##
# Extended Message Fields
#
class ::JuniperNetworksSensors < ::Protobuf::Message
  optional ::Port_exp, :".jnpr_interface_exp_ext", 18, :extension => true
end

