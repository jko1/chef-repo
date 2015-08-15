include NetApp::Api
include Vsim::Api

action :setup_iscsi do
  
	ruby_block "setup iscsi session" do
		block do
			# Actions on node1
			execute_cmd =  "ssh diag@" + node['node_list'][0] +  ".sim.netapp.com "
			execute_cmd += "\"sudo kenv -p bootarg.iscsi_mediator_ip=10.235.14.141;"
			execute_cmd += "sudo kenv -p bootarg.iscsi_mediator_tgt=iqn.2012-05.local:mailbox.group." + node['lun_name'] + "\" "
			system execute_cmd	

			# Actions on node2	
			execute_cmd =  "ssh diag@" + node['node_list'][1] +  ".sim.netapp.com "
			execute_cmd += "\"sudo kenv -p bootarg.iscsi_mediator_ip=10.235.14.141;"
			execute_cmd += "sudo kenv -p bootarg.iscsi_mediator_tgt=iqn.2012-05.local:mailbox.group." + node['lun_name'] + "\" "
			system execute_cmd	

		end
	end

	new_resource.updated_by_last_action(true) 

end


action :setup_mediator_disk do 

	ruby_block "get mediator disk" do
		block do
			ssh_str = "ssh admin@" + node['node_list'][0] +  ".sim.netapp.com "
			ssh_str += " \" node run -node koj-vsim1 -command \"disk show -n \" \" "
			result = %x( #{ssh_str} )
			mediator_disk = []
			result.each_line do |line|
    			if line[0,2] == '0f' and mediator_disk.length!=2
    				# Gets disk name
    				temp = line.gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")[0]
    				mediator_disk.push(temp)
				end
			end
			
			if mediator_disk.length==2
				ssh_str = "ssh admin@" + node['node_list'][0] +  ".sim.netapp.com "
				ssh_str +=  " \" node run -node " + node['node_list'][0] + " -command \"disk assign " + mediator_disk[0] + "\";"
				ssh_str +=  " node run -node " + node['node_list'][1] + " -command \"disk assign " + mediator_disk[1] + "\" \" "
				cmd_result = system ssh_str
				new_resource.updated_by_last_action(true) if cmd_result
			end 
		end
	end
end


