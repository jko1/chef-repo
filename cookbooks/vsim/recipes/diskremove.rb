vsim_disk "filler name" do
	disk_list ["VMw-1.40", "VMw-1.41"] #Change names depending on disks
	action :remove_owner
end