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
				if resource_id.include? "http"
					query = Query.new
					results = query.subject("<" + resource_id + ">")
					resource_url = resource_id
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
				klass = Lbp.const_get(type.capitalize)
				klass.new(resource_url, results)
			rescue NameError
				Resource.new(resource_url, results)
			end
		end
		# end class level methods
		attr_reader :short_id, :url, :rdf_uri, :results
		
		def initialize(resource_url, results)
			@results = results
			
			# this is copied from resource_identifier
			@rdf_uri = new RDF::URI.new(resource_url)
			@url = resource_url
			@short = if resource_url.include? "property/"
				@url.split("property/").last
			else
				@url.split("resource/").last
			end
		end
		def to_s
			@url
		end
		#generic query methods for all resources
		def values(property) # should return an array of resource identifiers
			results = self.results.dup.filter(:p => RDF::URI(property))
			array = results.map {|m| ResourceIdentifier.new(m[:o].to_s)}
			return array
		end

		def value(property) # should return a single resource identifier; and error if there is more than one property for this value
			value = @results.dup.filter(:p => RDF::URI(property)).first[:o]
			ResourceIdentifier.new(value)
		end

		#query for properties global to all resources
		def type
			self.value("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
		end
		def title
			#careful here; title in db is not actualy a uri, but a litteral
			#to_s method should work, but it might not be correct for this to be initially 
			#instantiated into a resource identifer. 
			# This is why I'm forcing the to_s method in the return value rather than 
			# return the ResourceIdentifer object itself as in the case of type above
			self.value(RDF::Vocab::DC11.title).to_s
		end
		def description
			#TODO add description here
		end
	end
end