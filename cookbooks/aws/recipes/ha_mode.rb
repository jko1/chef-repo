vsim_cf node['node_list'][0] do
	mode "ha"
	action :mode
end

vsim_cf node['node_list'][1] do
	mode "ha"
	action :mode
end