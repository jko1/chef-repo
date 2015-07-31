vsim_disk "filler name" do
	disk_list ["VMw-1.10", "VMw-1.11"] #Change names depending on disks
	action :remove_owner
end