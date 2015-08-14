include NetApp::Api
include Vsim::Api

action :create do 

	ssh_str = "ssh " + node['username'] + "@" + node['host']
	ssh_str += " \" curl -X DELETE http://10.235.14.141:3000/mediator/" + node['lun_name']+ ";"
	ssh_str += "curl -X PUT http://10.235.14.141:3000/mediator/" + node['lun_name'] + "\""
	execute  ssh_str do
		new_resource.updated_by_last_action(true) 
	end

end