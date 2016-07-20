require 'rdf'

module Lbp
	class ResourceIdentifier
		attr_reader :short_id, :url, :rdf_uri
		class << self
			def from_short(short)
				new RDF::URI.new("http://scta.info/resource/#{short}")
			end
			def from_url(url)
				new RDF::URI.new(url)
			end
			def from_rdf_uri(rdf_uri)
				new rdf_uri
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
			@object = Resource.find(url)
		end
		def to_s
			@url
		end
	end
end
