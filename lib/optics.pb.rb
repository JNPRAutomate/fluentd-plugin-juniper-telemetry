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
class Optics < ::Protobuf::Message; end
class OpticsInfos < ::Protobuf::Message; end
class OpticsDiagStats < ::Protobuf::Message; end
class OpticsDiagLaneStats < ::Protobuf::Message; end


##
# Message Fields
#
class Optics
  repeated ::OpticsInfos, :Optics_diag, 1
end

class OpticsInfos
  required :string, :if_name, 1, :".telemetry_options" => { :is_key => true }
  optional :uint32, :snmp_if_index, 2
  optional ::OpticsDiagStats, :optics_diag_stats, 3
end

class OpticsDiagStats
  optional :uint32, :optics_type, 1
  optional :double, :module_temp, 2, :".telemetry_options" => { :is_gauge => true }
  optional :double, :module_temp_high_alarm_threshold, 3, :".telemetry_options" => { :is_gauge => true }
  optional :double, :module_temp_low_alarm_threshold, 4, :".telemetry_options" => { :is_gauge => true }
  optional :double, :module_temp_high_warning_threshold, 5, :".telemetry_options" => { :is_gauge => true }
  optional :double, :module_temp_low_warning_threshold, 6, :".telemetry_options" => { :is_gauge => true }
  optional :double, :laser_output_power_high_alarm_threshold_dbm, 7, :".telemetry_options" => { :is_gauge => true }
  optional :double, :laser_output_power_low_alarm_threshold_dbm, 8, :".telemetry_options" => { :is_gauge => true }
  optional :double, :laser_output_power_high_warning_threshold_dbm, 9, :".telemetry_options" => { :is_gauge => true }
  optional :double, :laser_output_power_low_warning_threshold_dbm, 10, :".telemetry_options" => { :is_gauge => true }
  optional :double, :laser_rx_power_high_alarm_threshold_dbm, 11, :".telemetry_options" => { :is_gauge => true }
  optional :double, :laser_rx_power_low_alarm_threshold_dbm, 12, :".telemetry_options" => { :is_gauge => true }
  optional :double, :laser_rx_power_high_warning_threshold_dbm, 13, :".telemetry_options" => { :is_gauge => true }
  optional :double, :laser_rx_power_low_warning_threshold_dbm, 14, :".telemetry_options" => { :is_gauge => true }
  optional :double, :laser_bias_current_high_alarm_threshold, 15, :".telemetry_options" => { :is_gauge => true }
  optional :double, :laser_bias_current_low_alarm_threshold, 16, :".telemetry_options" => { :is_gauge => true }
  optional :double, :laser_bias_current_high_warning_threshold, 17, :".telemetry_options" => { :is_gauge => true }
  optional :double, :laser_bias_current_low_warning_threshold, 18, :".telemetry_options" => { :is_gauge => true }
  optional :bool, :module_temp_high_alarm, 19
  optional :bool, :module_temp_low_alarm, 20
  optional :bool, :module_temp_high_warning, 21
  optional :bool, :module_temp_low_warning, 22
  repeated ::OpticsDiagLaneStats, :optics_lane_diag_stats, 23
end

class OpticsDiagLaneStats
  optional :uint32, :lane_number, 1, :".telemetry_options" => { :is_key => true }
  optional :double, :lane_laser_temperature, 2, :".telemetry_options" => { :is_gauge => true }
  optional :double, :lane_laser_output_power_dbm, 3, :".telemetry_options" => { :is_gauge => true }
  optional :double, :lane_laser_receiver_power_dbm, 4, :".telemetry_options" => { :is_gauge => true }
  optional :double, :lane_laser_bias_current, 5
  optional :bool, :lane_laser_output_power_high_alarm, 6
  optional :bool, :lane_laser_output_power_low_alarm, 7
  optional :bool, :lane_laser_output_power_high_warning, 8
  optional :bool, :lane_laser_output_power_low_warning, 9
  optional :bool, :lane_laser_receiver_power_high_alarm, 10
  optional :bool, :lane_laser_receiver_power_low_alarm, 11
  optional :bool, :lane_laser_receiver_power_high_warning, 12
  optional :bool, :lane_laser_receiver_power_low_warning, 13
  optional :bool, :lane_laser_bias_current_high_alarm, 14
  optional :bool, :lane_laser_bias_current_low_alarm, 15
  optional :bool, :lane_laser_bias_current_high_warning, 16
  optional :bool, :lane_laser_bias_current_low_warning, 17
  optional :bool, :lane_tx_loss_of_signal_alarm, 18
  optional :bool, :lane_rx_loss_of_signal_alarm, 19
  optional :bool, :lane_tx_laser_disabled_alarm, 20
end


##
# Extended Message Fields
#
class ::JuniperNetworksSensors < ::Protobuf::Message
  optional ::Optics, :".jnpr_optics_ext", 10, :extension => true
end

