vsim_disk "koj-vsim1" do
	disk_count 5
	disk_list ["VMw-1.40", "VMw-1.41"] 
	action :assign
end

vsim_disk "koj-vsim2" do
	disk_count 5
	action :assign
end