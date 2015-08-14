# Cookbook Name:: vsim
# Resource:: disk

include NetApp::Api
include Vsim::Api

action :assign do

	if new_resource.disk_count.nil? and new_resource.disk_list.nil? 
	  raise ArgumentError, "Must specify disk_count or disk_list."
	end

	resource_update = true

	if !new_resource.disk_count.nil?
		netapp_aggr_api = netapp_hash

		netapp_aggr_api[:api_name] = "disk-sanown-assign"
		netapp_aggr_api[:resource] = "disk"
		netapp_aggr_api[:action] = "assign"
		netapp_aggr_api[:api_attribute]["owner"] = new_resource.name
		netapp_aggr_api[:api_attribute]["disk-count"] = new_resource.disk_count
		resource_update = resource_update && invoke(netapp_aggr_api) 
	end
	
	if !new_resource.disk_list.nil? 
		netapp_aggr_api = netapp_hash

		netapp_aggr_api[:api_name] = "disk-sanown-assign"
		netapp_aggr_api[:resource] = "disk"
		netapp_aggr_api[:action] = "assign"
		netapp_aggr_api[:api_attribute]["owner"] = new_resource.name
		netapp_aggr_api[:api_attribute]["disk"] = new_resource.disk_list
		resource_update = resource_update && invoke(netapp_aggr_api) 
	end

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


# Removes ownership from spare disks
# Assign a disk from each node to pool1
action :create_pool_spare do

	if node['node_list'].length!=2
	  raise ArgumentError, "Node-name needs to be an array of length 2."
	end 
	
	# Create API Request.
	netapp_aggr_api = netapp_hash

	netapp_aggr_api[:api_name] = "storage-disk-get-iter"
	netapp_aggr_api[:resource] = "disk"
	netapp_aggr_api[:action] = "create_pool_spare"
	request = generate_request(netapp_aggr_api[:api_name], netapp_aggr_api[:api_attribute])

	query_xml =  NaElement.new("query")
	disk_info_xml =  NaElement.new("storage-disk-info")
	raid_info_xml =  NaElement.new("disk-raid-info")
	raid_info_xml.child_add(NaElement.new("container-type", "spare"))
	disk_info_xml.child_add(raid_info_xml)
	query_xml.child_add(disk_info_xml)
	request.child_add(query_xml) 

	desired = NaElement.new("desired-attributes")
	disk_info =  NaElement.new("storage-disk-info")
	disk_info.child_add(NaElement.new("disk-name", "filler string"))
	disk_own = NaElement.new("disk-ownership-info")
	disk_own.child_add(NaElement.new("owner-node-name", "filler string"))
	disk_info.child_add(disk_own)

	desired.child_add(disk_info)
	request.child_add(desired) 

	#Get disknames of spares and two spare disks owned by node1
	invoke_result = invoke_NAElem_disknames(netapp_aggr_api, request, node['node_list'])

	if invoke_result == false 
		resource_update = false
	else
		#Results interpreted based on function
		disk_name_list = invoke_result[0] 
		pool_spare = invoke_result[1]

		# Create API Request.
		netapp_aggr_api = netapp_hash

		netapp_aggr_api[:api_name] = "disk-sanown-remove-ownership"
		netapp_aggr_api[:resource] = "disk"
		netapp_aggr_api[:action] = "create_pool_spare"
		request = generate_request(netapp_aggr_api[:api_name], netapp_aggr_api[:api_attribute])

		request.child_add(nest_elem("disk-list", "disk-name", disk_name_list))

		# Remove ownership on spare disks
	    resource_update = invoke_NAElem(netapp_aggr_api, request)

	    # Assign a spare disk previous owned by node1
	    # To each of the nodes
	    # as pool1
	    for iter in 0 ... 2
		    netapp_aggr_api[:api_name] = "disk-sanown-assign"
			netapp_aggr_api[:resource] = "disk"
			netapp_aggr_api[:action] = "create_pool_spare"
			netapp_aggr_api[:api_attribute]["owner"] = node['node_list'][iter]
			netapp_aggr_api[:api_attribute]["disk"] = pool_spare[iter]
			netapp_aggr_api[:api_attribute]["pool"] = 1
			resource_update = resource_update && invoke(netapp_aggr_api) 
		end
	end
	new_resource.updated_by_last_action(true) if resource_update
end

action :auto_assign do 

	if new_resource.auto.nil? 
		raise ArgumentError, "Auto attribute needs to a boolean."
	end 		

	ssh_str =  "ssh admin@" + node['node_list'][0] +  ".sim.netapp.com "
	ssh_str += "\" disk option modify -autoassign "
	if new_resource.auto
		ssh_str += "on"
	else 
		ssh_str += "off"
	end
	ssh_str += " -node "

	if new_resource.name == "all"
		ssh_str += "* \""
	else 
		ssh_str += new_resource.name + " \""
	end

	execute ssh_str do
		new_resource.updated_by_last_action(true) 
	end
end