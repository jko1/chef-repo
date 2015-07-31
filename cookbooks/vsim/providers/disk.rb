# Cookbook Name:: vsim
# Resource:: disk

include NetApp::Api
include Vsim::Api

action :assign do

	# Create API Request.
	netapp_aggr_api = netapp_hash

	netapp_aggr_api[:api_name] = "disk-sanown-assign"
	netapp_aggr_api[:resource] = "disk"
	netapp_aggr_api[:action] = "assign"
	netapp_aggr_api[:api_attribute]["owner"] = new_resource.name
	netapp_aggr_api[:api_attribute]["disk-count"] = new_resource.disk_count unless new_resource.disk_count.nil?


  # Invoke NetApp API.
  resource_update = invoke(netapp_aggr_api)
  new_resource.updated_by_last_action(true) if resource_update
end


action :remove_owner do
	if new_resource.disk_list.nil?
	  raise ArgumentError, "No disks given to remove ownership"
	end 

	# Create API Request.
	netapp_aggr_api = netapp_hash

	netapp_aggr_api[:api_name] = "disk-sanown-remove-ownership"
	netapp_aggr_api[:resource] = "disk"
	netapp_aggr_api[:action] = "remove"

  # Make XML
  request = generate_request(netapp_aggr_api[:api_name], netapp_aggr_api[:api_attribute])
  request.child_add(nest_elem("disk-list", "disk-name", new_resource.disk_list))

  #Invoke API
  resource_update = invoke_NAElem(netapp_aggr_api, request)

  new_resource.updated_by_last_action(true) if resource_update

end