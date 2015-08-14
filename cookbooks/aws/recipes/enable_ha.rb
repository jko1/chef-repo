vsim_cf node['node_list'][0] do
	action :service_enable
end

vsim_cf node['node_list'][1] do
	action :service_enable
end