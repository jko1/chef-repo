vsim_disk "koj-vsim1" do
	disk_count 5
	action :assign
end

vsim_disk "koj-vsim2" do
	disk_count 5
	action :assign
end


netapp_aggregate "aggrdemoA" do
	disk_count 5
  	action :create
end

netapp_aggregate "aggrdemoB" do
	disk_count 5
  	nodes ["<node-name>koj-vsim2</node-name>"] #Works when commenting out in NaElement::EscapeHTML
  	action :create
end
