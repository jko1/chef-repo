netapp_aggregate "aggrdemoA" do
  	action :delete
end

netapp_aggregate "aggrdemoB" do
	action :delete
end

vsim_disk "filler name" do
	disk_list ["<disk-name>VMw-1.41</disk-name>, <disk-name>VMw-1.42</disk-name>"] #Change names depending on disks
	action :delete
end

