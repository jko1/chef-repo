# Cookbook Name:: vsim
# Resource:: vsim

actions :setup, :teardown, :ha_mode
default_action :setup

attribute :profile, :kind_of => String, :default => "vsimcha2n12"