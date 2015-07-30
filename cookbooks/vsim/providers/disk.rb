# Cookbook Name:: vsim
# Resource:: disk

include NetApp::Api

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

    # Add list of disks to remove
    disk_xml =  NaElement.new("disk-list")
    new_resource.disk_list.each do |disk_name|
	    disk_xml.child_add(NaElement.new("disk-name", disk_name))
    end
    request.child_add(disk_xml)

    # Lines from invoke function
    if netapp_aggr_api[:svm].empty?
      response = invoke_api(request)
    else
      response = invoke_api(request, netapp_aggr_api[:svm])
    end
    resource_update = check_errors!(response, netapp_aggr_api[:resource], netapp_aggr_api[:action])
    new_resource.updated_by_last_action(true) if resource_update

end