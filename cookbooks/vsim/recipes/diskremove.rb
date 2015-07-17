vsim_disk "filler name" do
	disk_list ["VMw-1.18", "VMw-1.19", "VMw-1.17", "VMw-1.16", "VMw-1.15"] #Change names depending on disks
	action :remove_owner
end