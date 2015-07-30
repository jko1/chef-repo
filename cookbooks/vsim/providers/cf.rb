include NetApp::Api

action :takeover do

  # Create API Request.
  netapp_aggr_api = netapp_hash

  netapp_aggr_api[:api_name] = "cf-takeover"
  netapp_aggr_api[:resource] = "cf"
  netapp_aggr_api[:action] = "takeover"
  netapp_aggr_api[:api_attribute]["node"] = new_resource.name

  # Invoke NetApp API.
  resource_update = invoke(netapp_aggr_api)
  new_resource.updated_by_last_action(true) if resource_update
end

action :giveback do

  # Create API Request.
  netapp_aggr_api = netapp_hash

  netapp_aggr_api[:api_name] = "cf-giveback"
  netapp_aggr_api[:resource] = "cf"
  netapp_aggr_api[:action] = "giveback"
  netapp_aggr_api[:api_attribute]["node"] = new_resource.name

  # Invoke NetApp API.
  resource_update = invoke(netapp_aggr_api)
  new_resource.updated_by_last_action(true) if resource_update
end
