# Cookbook Name:: vsim
# Resource:: vsim

include NetApp::Api

acceptable_profiles = ["vsimcha2n12", "vsimcha2n34"]

action :setup do

	if not acceptable_profiles.include?(new_resource.profile) 
		raise ArgumentError, "Not an acceptable profile."
	end

	# Run the command "vsim make -pro <profile_name> -ir <build_path> -auto"
	execute  "ssh " + node['username'] + "@" + node['host'] + " \" vsim make -pro " + new_resource.profile + " -ir " + node['build_path'] + " -auto \"" do
		new_resource.updated_by_last_action(true) 
	end
	
end

action :teardown do
	execute  "ssh " + node['username'] + "@" + node['host'] + " \" rm -rf " + node['vsim_path'] + "/* \"" do
		new_resource.updated_by_last_action(true) 
	end
	
end

action :ha_mode do

	if not acceptable_profiles.include?(new_resource.profile) 
		raise ArgumentError, "Not an acceptable profile."
	end


	if new_resource.profile[-1] == '2'
		node_name = ["vsim1", "vsim2"]
	else 
		node_name = ["vsim3", "vsim4"]
	end

	ruby_block "ha mode" do
		block do
			# Restart
			execute_cmd =  "ssh admin@" + node['username'] + "-" + node_name[0] +  ".sim.netapp.com "
			execute_cmd += "\"system node reboot -node " + node['username'] + "-" + node_name[1] +  " -ignore-quorum-warnings;"
			execute_cmd += "sleep 270;"
			execute_cmd += "system node reboot -node " + node['username'] + "-" + node_name[0] +  " -ignore-quorum-warnings\" "
			system execute_cmd	

			#Set HA Mode		
			execute_cmd =  "ssh admin@" + node['username'] + "-" + node_name[1] +  ".sim.netapp.com "
			execute_cmd += "sleep 250;"
			execute_cmd += "cluster ha modify -configured true"
			system execute_cmd

		end
	end
end