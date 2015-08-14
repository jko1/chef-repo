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

