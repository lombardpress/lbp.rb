require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'
require 'rdf/vocab'
require 'lbp'


module Lbp
	class Resource 
		attr_reader :resource_id, :results
		def initialize(resource_id)
			@resource_id = resource_id

			if @resource_id.include? "http"
				@query = Query.new();
				@results = @query.subject("<" + @resource_id + ">")
			else
				@query = Query.new();
				@results = @query.subject_with_short_id(@resource_id)
			end
		end
		def type
			type = @results.dup.filter(:p => RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")).first[:o].to_s.split("/").last
		end
		def type_url
			type = @results.dup.filter(:p => RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")).first[:o].to_s
		end
		def title
			type = @results.dup.filter(:p => RDF::URI(RDF::Vocab::DC11.title)).first[:o].to_s
		end
		def structureType
			type = @results.dup.filter(:p => RDF::URI("http://scta.info/property/structureType")).first[:o].to_s.split("/").last
		end
		def structureType_url
			type = @results.dup.filter(:p => RDF::URI("http://scta.info/property/structureType")).first[:o].to_s
		end
	end
end