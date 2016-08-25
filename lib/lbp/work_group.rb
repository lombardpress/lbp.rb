module Lbp
	class WorkGroup < Resource
		## works groups can contain other work groups
		## but works groups should really only list child workGroups and this 
		## this should be covered through the generic has_parts method
		## db currently has "hasWorkGroup" and this needs to be changed to "hasPart"
		## before this method can be removed 
		def work_groups
			values("http://scta.info/property/hasWorkGroup")
		end
		def expressions
			values("http://scta.info/property/hasExpression")
		end
		
	end
end
