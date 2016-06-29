require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'
require 'rdf/vocab'
require 'lbp'


module Lbp
	class Resource 
		## TODO think about making a class level method called "find" to replace "convert" the result 
		## of which would be the instantiation of the appropriate class
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
		attr_reader :resource_shortId, :resource_url, :results
		
		def initialize(resource_url, results)
			@results = results
			@resource_url = resource_url
			@resource_shortId = resource_url.split("resource/").last
		end
		def type
			type = @results.dup.filter(:p => RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")).first[:o]
			ResourceIdentifier.new(type)
		end
		def title
			title = @results.dup.filter(:p => RDF::URI(RDF::Vocab::DC11.title)).first[:o].to_s
		end
		## structure type should be moved to expression and other classes because it's not generic enough
		## some resources like quotes or name will not have structure type
		def structureType
			type = @results.dup.filter(:p => RDF::URI("http://scta.info/property/structureType")).first[:o]
			ResourceIdentifier.new(type)
		end
	end
end