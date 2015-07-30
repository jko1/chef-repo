vsim_aggregate "aggrdemoA" do
	disk_count 5
  	action :create
end

vsim_aggregate "aggrdemoB" do
	disk_count 5
  	nodes "koj-vsim2"
  	action :create
end
