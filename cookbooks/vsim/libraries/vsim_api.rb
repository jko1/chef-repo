# Functions here are used for invoking and creating
# NAElements for attributes that their own type.
# eg. node-name[] for aggr
include NetApp::Api

module Vsim
	module Api

		# This contains original code from invoke() of netapp_api
		# Request is an NAElement 
		# Can be created from generate_request()
		def invoke_NAElem(api_hash, request)
		      if api_hash[:svm].empty?
		        response = invoke_api(request)
		      else
		        response = invoke_api(request, api_hash[:svm])
		      end
		      check_errors!(response, api_hash[:resource], api_hash[:action])
		end

		# Creates nested NAElements 
		# eg. <root_name>
		# 		<child_name> value1 </child_name>
		# 		...
		# 		<child_name> value2 </child_name>
		# 	</root_name>
		# Values can be a string or array; names are strings
		def nest_elem(root_name, child_name, values)
			xml = NaElement.new(root_name)
			if values.instance_of? String
	    		xml.child_add(NaElement.new(child_name, values))
	    	else 
	    		values.each do |value|
	    			xml.child_add(NaElement.new(child_name, value))
	    		end
	    	end
	   		return xml
	   	end

	   	# Used for create_pool_spare
	   	# Finds spare disks
	   	# Node_list should be array [node1, node2]
	   	# Returns false if any call was unsucessful
	   	# Return [[disk_names of spares], [spare disk on node2, spare disk on node1]] 
		def invoke_NAElem_disknames(api_hash, request, node_list)

	   		if api_hash[:svm].empty?
		        response = invoke_api(request)
		    else
		        response = invoke_api(request, api_hash[:svm])
		    end
		    
		    #Successful invoke
		    if check_errors!(response, api_hash[:resource], api_hash[:action])
				# Get disk-names and disks for pool1
				disk_name_list = []
				pool_spare = []
				if response.child_get("attributes-list").nil? or response.child_get("attributes-list").children_get().nil?
					return false
				end
				response.child_get("attributes-list").children_get().each do | child |
				    disk_name_temp = child.child_get("disk-name").sprintf()[11..-14]
				    disk_name_list.push(disk_name_temp)
				    #Want to go in reverse for switching disks
				    if pool_spare.length!=2 and child.child_get("disk-ownership-info").child_get("owner-node-name").sprintf[17...-19] == node_list[1-pool_spare.length]
				        pool_spare.push(disk_name_temp)
				    end
				end
				if pool_spare.length!=2
					return false 
				end
				return [disk_name_list, pool_spare]

		    else 
		    	return false
			end
		end


	end
end