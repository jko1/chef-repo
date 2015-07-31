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
		# Values can be a string or array
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

	end
end