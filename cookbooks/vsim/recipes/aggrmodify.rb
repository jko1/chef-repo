vsim_aggregate "aggrdemoB" do
	state "offline"
	action :state
end

vsim_aggregate "koj-vsim2" do
	source_node_name "koj-vsim1"
	aggregate_list ["aggrdemoA"]
  	action :relocation
end

vsim_aggregate "aggrdemoA" do
	new_aggr_name "new_aggrdemoA"
	action :rename
end

vsim_aggregate "new_aggrdemoA" do
	disk_count 5
	action :add
end
