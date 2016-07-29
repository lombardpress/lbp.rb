module Lbp
	class WorkGroup < Resource
		## works groups can contain other work groups
		def work_groups
			values("http://scta.info/property/hasWorkGroup")
		end
		def expressions
			values("http://scta.info/property/hasExpression")
		end
		
	end
end
