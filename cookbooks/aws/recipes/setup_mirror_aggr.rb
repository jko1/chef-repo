vsim_disk "all" do
	auto false
	action :auto_assign
end

vsim_disk "filler name" do
	action :create_pool_spare
end

vsim_aggregate "aggr0_" + node['node_list'][1].gsub('-','_') + "_0" do
	action :mirror
end

vsim_aggregate "aggr0" do
	action :mirror
end