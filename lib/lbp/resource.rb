require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'
require 'rdf/vocab'
require 'lbp'


module Lbp
	class Resource 
		attr_reader :resource_shortId, :resource_url, :results
		def initialize(resource_id)
			# fist conditions check to see if search results 
			# are being passed
			if resource_id.class != String
				@results = resource_id
				# resource should should be returned instead of "unsure"
				@resource_shortId = @results.first[:s].to_s.split("resource/").last
				@resource_url = @results.first[:s].to_s
				# if resource id is a string rather than results 
			# it looks ot see if this is a URL to query for results	
			elsif resource_id.include? "http"
				@query = Query.new();
				@results = @query.subject("<" + resource_id + ">")
				@resource_url = resource_id
				@resource_shortId = resource_id.split("resource/").last
			# finally, it looks for results using the shortId
			else
				@query = Query.new();
				@results = @query.subject_with_short_id(resource_id)
				@resource_url = "http://scta.info/resource/" + resource_id
				@resource_shortId = resource_id
			end
		end
		def convert
			#this conditional should be replaced 
			# by a function that converts the string
			# into a class name
			if self.type_shortId == 'workGroup'
				return WorkGroup.new(@results)
			elsif self.type_shortId == 'work'
				return Work.new(@results)
			elsif self.type_shortId == 'expression'
				return Expression.new(@results)
			elsif self.type_shortId == "manifestation"
				return Manifestation.new(@results)
			elsif self.type_shortId == "transcription"
				return Transcription.new(@results)
			else
				puts "no subclass to conver to"
				return self
			end
		end
		def type_shortId
			type = @results.dup.filter(:p => RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")).first[:o].to_s.split("/").last
		end
		def type
			type = @results.dup.filter(:p => RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")).first[:o].to_s
		end
		def title
			type = @results.dup.filter(:p => RDF::URI(RDF::Vocab::DC11.title)).first[:o].to_s
		end
		## structure type should be moved to expression and other classes because it's not generic enough
		## some resources like quotes or name will not have structure type
		def structureType_shortId
			type = @results.dup.filter(:p => RDF::URI("http://scta.info/property/structureType")).first[:o].to_s.split("/").last
		end
		def structureType
			type = @results.dup.filter(:p => RDF::URI("http://scta.info/property/structureType")).first[:o].to_s
		end
	end
end