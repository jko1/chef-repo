vsim_aggregate "aggr0_" + node['node_list'][1].gsub!('-','_') + "_0" do
	action :mirror
end

vsim_aggregate "aggr0" do
	action :mirror
end