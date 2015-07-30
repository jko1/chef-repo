vsim_cf "koj-vsim2" do
	node.default['netapp']['fqdn'] = 'koj-vsim2.sim.netapp.com'
  	action :giveback
end