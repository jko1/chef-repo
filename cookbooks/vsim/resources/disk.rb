# Cookbook Name:: vsim
# Resource:: disk

actions :assign, :remove_owner, :create_pool_spare, :auto_assign
default_action :assign

attribute :name, :kind_of => String, :required => true, :name_attribute => true

attribute :disk_count, :kind_of => Integer
attribute :disk_list, :kind_of => Array
attribute :auto, :kind_of => [TrueClass, FalseClass]
attribute :container_type, :kind_of => String