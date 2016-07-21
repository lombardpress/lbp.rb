require 'rdf'
require 'lbp'

module Lbp
	###NOTE #rdf_uri can be a littel confusing, since it also works for RDF::Literal
	class ResourceIdentifier
		attr_reader :short_id, :url, :rdf_uri
		class << self
			def from_short(short)
				RDF::URI.new("http://scta.info/resource/#{short}")
			end
			def from_url(url)
				RDF::URI.new(url)
			end
			def from_rdf_uri(rdf_uri)
				rdf_uri
			end
		end

		def initialize(rdf_uri)
			@rdf_uri = rdf_uri
			@url = rdf_uri.to_s
			@short_id = if @url.include? "property/"
				@url.split("property/").last
			else
				@url.split("resource/").last
			end
		end
		def to_s
			@url
		end
		def object
			unless @rdf_uri.class == RDF::Literal
				object = Lbp::Resource.find(url)
			else 
				nil
			end
		end
	end
end
