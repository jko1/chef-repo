# Cookbook Name:: vsim
# Provider:: aggregate
#
# Copyright:: 2014, Chef Software, Inc <legal@getchef.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This is an altered version. 
# Only changed the :create.
# The difference is how the node-name is put in XML format.

include NetApp::Api
include Vsim::Api

action :create do
  # validations
  raise ArgumentError, "Aggregate name should be less than 255 characters" if new_resource.name.length > 255

  # Create API Request.
  netapp_aggr_api = netapp_hash

  netapp_aggr_api[:api_name] = "aggr-create"
  netapp_aggr_api[:resource] = "aggregate"
  netapp_aggr_api[:action] = "create"
  netapp_aggr_api[:api_attribute]["aggregate"] = new_resource.name
  netapp_aggr_api[:api_attribute]["allow-mixed-rpm"] = new_resource.allow_mixed_rpm unless new_resource.allow_mixed_rpm.nil?
  netapp_aggr_api[:api_attribute]["allow-same-carrier"] = new_resource.allow_same_carrier unless new_resource.allow_same_carrier.nil?
  netapp_aggr_api[:api_attribute]["block-type"] = new_resource.block_type unless new_resource.block_type.nil?
  netapp_aggr_api[:api_attribute]["checksum-style"] = new_resource.checksum_style unless new_resource.checksum_style.nil?
  netapp_aggr_api[:api_attribute]["disk-count"] = new_resource.disk_count unless new_resource.disk_count.nil?
  netapp_aggr_api[:api_attribute]["disk-size"] = new_resource.disk_size unless new_resource.disk_size.nil?
  netapp_aggr_api[:api_attribute]["disk-size-with-unit"] = new_resource.disk_size_with_unit unless new_resource.disk_size_with_unit.nil?
  netapp_aggr_api[:api_attribute]["disk-type"] = new_resource.disk_type unless new_resource.disk_type.nil?
  netapp_aggr_api[:api_attribute]["disks"] = new_resource.disks unless new_resource.disks.nil?
  netapp_aggr_api[:api_attribute]["force-small-aggregate"] = new_resource.force_small_aggregate unless new_resource.force_small_aggregate.nil?
  netapp_aggr_api[:api_attribute]["force-spare-pool"] = new_resource.force_spare_pool unless new_resource.force_spare_pool.nil?
  netapp_aggr_api[:api_attribute]["ignore-pool-checks"] = new_resource.ignore_pool_checks unless new_resource.ignore_pool_checks.nil?
  netapp_aggr_api[:api_attribute]["is-mirrored"] = new_resource.is_mirrored unless new_resource.is_mirrored.nil?
  netapp_aggr_api[:api_attribute]["mirror-disks"]["disk-info"]["name"] = new_resource.mirror_disks unless new_resource.mirror_disks.nil?
  netapp_aggr_api[:api_attribute]["pre-check"] = new_resource.pre_check unless new_resource.pre_check.nil?
  netapp_aggr_api[:api_attribute]["raid-size"] = new_resource.raid_size unless new_resource.raid_size.nil?
  netapp_aggr_api[:api_attribute]["raid-type"] = new_resource.raid_type unless new_resource.raid_type.nil?
  netapp_aggr_api[:api_attribute]["rpm"] = new_resource.rpm unless new_resource.rpm.nil?
  netapp_aggr_api[:api_attribute]["striping"] = new_resource.striping unless new_resource.striping.nil?

  if not new_resource.nodes.nil? 

    #Make XML
    request = generate_request(netapp_aggr_api[:api_name], netapp_aggr_api[:api_attribute])
    request.child_add(nest_elem("nodes", "node-name", new_resource.nodes))
    
    #Invoke API
    resource_update = invoke_NAElem(netapp_aggr_api, request)

  else # Normal execution
    resource_update = invoke(netapp_aggr_api)
  end
    new_resource.updated_by_last_action(true) if resource_update
end

action :delete do
  # Create API Request.
  netapp_aggr_api = netapp_hash

  netapp_aggr_api[:api_name] = "aggr-destroy"
  netapp_aggr_api[:resource] = "aggregate"
  netapp_aggr_api[:action] = "delete"
  netapp_aggr_api[:api_attribute]["aggregate"] = new_resource.name
  netapp_aggr_api[:api_attribute]["plex"] = new_resource.plex unless new_resource.plex.nil?

  # Invoke NetApp API.
  resource_update = invoke(netapp_aggr_api)
  new_resource.updated_by_last_action(true) if resource_update
end

action :relocation do

  if new_resource.source_node_name.nil? or new_resource.aggregate_list.nil? 
      raise ArgumentError, "Source node name or aggregate list is missing"
  end

  netapp_aggr_api = netapp_hash

  netapp_aggr_api[:api_name] = "aggr-relocation"
  netapp_aggr_api[:resource] = "aggregate"
  netapp_aggr_api[:action] = "relocation"

  #The destination node is the name of the resource
  netapp_aggr_api[:api_attribute]["destination-node-name"] = new_resource.name
  netapp_aggr_api[:api_attribute]["source-node-name"] = new_resource.source_node_name

  #Make XML
  request = generate_request(netapp_aggr_api[:api_name], netapp_aggr_api[:api_attribute])
  request.child_add(nest_elem("aggregate-list", "string", new_resource.aggregate_list))

  #Invoke API
  resource_update = invoke_NAElem(netapp_aggr_api, request)
  new_resource.updated_by_last_action(true) if resource_update

end

action :rename do 

  netapp_aggr_api = netapp_hash

  netapp_aggr_api[:api_name] = "aggr-rename"
  netapp_aggr_api[:resource] = "aggregate"
  netapp_aggr_api[:action] = "rename"

  netapp_aggr_api[:api_attribute]["aggregate"] = new_resource.name
  netapp_aggr_api[:api_attribute]["new-aggregate-name"] = new_resource.new_aggr_name

  # Invoke NetApp API.
  resource_update = invoke(netapp_aggr_api)
  new_resource.updated_by_last_action(true) if resource_update
end

action :state do

  if new_resource.state.nil?
      raise ArgumentError, "Aggregate state is missing."
  end

  netapp_aggr_api = netapp_hash
  if new_resource.state == "offline"
    netapp_aggr_api[:api_name] = "aggr-offline"
  elsif new_resource.state == "online"
    netapp_aggr_api[:api_name] = "aggr-online"
  else
    raise ArgumentError, "Only valid states are offline and online."
  end

  netapp_aggr_api[:resource] = "aggregate"
  netapp_aggr_api[:api_attribute]["aggregate"] = new_resource.name
  netapp_aggr_api[:action] = "state"

  # Invoke NetApp API.
  resource_update = invoke(netapp_aggr_api)
  new_resource.updated_by_last_action(true) if resource_update

end

action :add do 

  if !(new_resource.disks.nil? ^ new_resource.disk_count.nil?)
    raise ArgumentError, "Either disks or disk_count must be filled."
  end

  netapp_aggr_api = netapp_hash

  netapp_aggr_api[:api_name] = "aggr-add"
  netapp_aggr_api[:resource] = "aggregate"
  netapp_aggr_api[:action] = "add"

  netapp_aggr_api[:api_attribute]["aggregate"] = new_resource.name

  if !new_resource.disk_count.nil?
    netapp_aggr_api[:api_attribute]["disk-count"] = new_resource.disk_count
    resource_update = invoke(netapp_aggr_api)
  else
    request = generate_request(netapp_aggr_api[:api_name], netapp_aggr_api[:api_attribute])
    disk_xml = NaElement.new("disks")

    new_resource.disks.each do |value| 
      disk_xml.child_add(nest_elem("disk-info", "name", value))
    end
    request.child_add(disk_xml)

    resource_update = invoke_NAElem(netapp_aggr_api, request)
  end

  new_resource.updated_by_last_action(true) if resource_update
end

action :mirror do
  # Create API Request.
  netapp_aggr_api = netapp_hash

  netapp_aggr_api[:api_name] = "aggr-mirror"
  netapp_aggr_api[:resource] = "aggregate"
  netapp_aggr_api[:action] = "mirror"
  netapp_aggr_api[:api_attribute]["aggregate"] = new_resource.name

  # Invoke NetApp API.
  resource_update = invoke(netapp_aggr_api)
  new_resource.updated_by_last_action(true) if resource_update

end