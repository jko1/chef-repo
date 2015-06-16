#
# Cookbook Name:: myapp
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "netapp"


# netapp_aggregate "aggrdemo" do
#   disk_count 5
#   action :create
# end

netapp_aggregate "aggrdemo" do
  action :delete
end