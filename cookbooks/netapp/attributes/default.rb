#template

#default[:netapp][:url] = "http://root:secret@pfiler01.example.com/vfiler01"

#### or

default[:netapp][:https] = true
default[:netapp][:user] = 'admin'
default[:netapp][:password] = 'netapp1!'
default[:netapp][:fqdn] = 'koj-vsim1.sim.netapp.com'
default[:netapp][:api][:timeout] = false
default[:netapp][:vserver] = false

