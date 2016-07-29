require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'
require 'rdf/vocab'
require 'lbp'


module Lbp
	class Resource 
		class << self
			def find(resource_id)
				#adding the to_s method allows a resource to be created 
				#by passing in an RDF::URL object as well as the url string.
				if resource_id.to_s.include? "http"
					query = Query.new
					results = query.subject("<" + resource_id.to_s + ">")
					resource_url = resource_id.to_s
					create(resource_url, results)
				else
					query = Query.new
					results = query.subject_with_short_id(resource_id)
					resource_url = "http://scta.info/resource/" + resource_id
					create(resource_url, results)
				end
			end
			def create(resource_url, results)
				type = results.dup.filter(:p => RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")).first[:o].to_s.split("/").last
				klass = if type == "workGroup" 
						Lbp.const_get("WorkGroup") 
					else
						Lbp.const_get(type.capitalize)
					end
				klass.new(resource_url, results)
			rescue NameError
				Resource.new(resource_url, results)
			end
		end
		
		# end class level methods
		
		attr_reader :identifier, :results 
		extend Forwardable 
		def_delegators :@identifier, :short_id, :url, :rdf_uri, :to_s
		
		def initialize(resource_url, results)
			# if there are problems with results being empty 
			# and, for example, dup or filter being called on a null class
			# consider changing the following line to @results = results || <an empty object for whatever results normally is>
			@results = results || RDF::Query::Solutions.new()
			@identifier = ResourceIdentifier.new(resource_url)
		end

		#generic query methods for all resources
		def values(property) # should return an array of resource identifiers
			results = self.results.dup.filter(:p => RDF::URI(property))
			array = results.map {|m| ResourceIdentifier.new(m[:o])}
			return array
		end

		def value(property) # should return a single resource identifier; and error if there is more than one property for this value
			value = @results.dup.filter(:p => RDF::URI(property))
			if value.count > 0 
				value = value.first[:o]
				ResourceIdentifier.new(value)
			else 
				nil
			end
			
		end

		#query for properties global to all resources
		def type
			value("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
		end
		def title
			#careful here; title in db is not actualy a uri, but a litteral
			#to_s method should work, but it might not be correct for this to be initially 
			#instantiated into a resource identifer. 
			# This is why I'm forcing the to_s method in the return value rather than 
			# return the ResourceIdentifer object itself as in the case of type above
			value(RDF::Vocab::DC11.title).to_s
		end
		def description
			value(RDF::Vocab::DC11.description).to_s
		end
		def has_parts
			values(RDF::Vocab::DC.hasPart)
		end
		def is_part_of
			value(RDF::Vocab::DC.isPartOf)
		end


	end
end