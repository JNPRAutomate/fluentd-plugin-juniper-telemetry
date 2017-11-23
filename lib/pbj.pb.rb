# encoding: utf-8

##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf'


##
# Imports
#
require 'google/protobuf/descriptor.pb'


##
# Enum Classes
#
class FieldType < ::Protobuf::Enum
  define :FT_DEFAULT, 0
  define :FT_CALLBACK, 1
  define :FT_POINTER, 4
  define :FT_STATIC, 2
  define :FT_IGNORE, 3
end


##
# Message Classes
#
class PBJOptions < ::Protobuf::Message; end


##
# File Options
#
#set_option :java_package, "net.juniper.pbj"


##
# Message Fields
#
class PBJOptions
  optional :int32, :max_size, 1
  optional :int32, :max_count, 2
  optional ::FieldType, :type, 3, :default => ::FieldType::FT_DEFAULT
  optional :bool, :long_names, 4, :default => true
  optional :bool, :packed_struct, 5, :default => false
  optional :bool, :skip_message, 6, :default => false
  optional :bool, :cache_size, 7, :default => true
end


##
# Extended Message Fields
#
class ::Google::Protobuf::FileOptions < ::Protobuf::Message
  optional ::PBJOptions, :".pbj_file_option", 1020, :extension => true
end

class ::Google::Protobuf::MessageOptions < ::Protobuf::Message
  optional ::PBJOptions, :".pbj_message_option", 1020, :extension => true
end

class ::Google::Protobuf::EnumOptions < ::Protobuf::Message
  optional ::PBJOptions, :".pbj_enum_option", 1020, :extension => true
end

class ::Google::Protobuf::FieldOptions < ::Protobuf::Message
  optional ::PBJOptions, :".pbj_field_option", 1020, :extension => true
end

