# Cookbook Name:: vsim
# Resource:: disk

actions :assign, :remove_owner
default_action :assign

#Serves as the owner name (create)
#disk name (remove)
attribute :name, :kind_of => String, :required => true, :name_attribute => true

attribute :disk_count, :kind_of => Integer
attribute :disk_list, :kind_of => Array

