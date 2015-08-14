#attributes

default[:username] = "koj"
default[:host] = "cyclsvl.eng.netapp.com"
default[:build_path] = "/u/koj/p4/clean"
default[:vsim_path] = "/u/koj/vsims"
default[:node_list] = ["koj-vsim1", "koj-vsim2"] #Must be in the order of node1 and then node2; use dashes not underscores
