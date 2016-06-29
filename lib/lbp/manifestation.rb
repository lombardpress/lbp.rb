require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'
require 'rdf/vocab'
require 'lbp'


module Lbp
	class Manifestation < Resource 
		
		#inherits initialization from Resource
		
		def transcriptionUrls
			results = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasTranscription"))
			transcriptions = results.map {|m| m[:o].to_s}
			return transcriptions
		end
		def canonicalTranscriptionUrl
			# TODO this check against an empty array should
			# occur everywhere the filter is used
			# maybe we need a helper function that does this once
			unless self.results.count == 0 
				transcriptionUrl = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasCanonicalTranscription")).first[:o].to_s
				return transcriptionUrl
			end
		end
		def canonicalTranscription
			url = self.canonicalTranscriptionUrl
			transcriptionObj = Resource.find(url)
			return transcriptionObj
		end
	end
end

		