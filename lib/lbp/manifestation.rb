require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'
require 'rdf/vocab'
require 'lbp'


module Lbp
	class Manifestation < Resource 
		
		#inherits initialization from Resource
		
		def transcriptions
			transcriptions = self.values("http://scta.info/property/hasTranscription")
			#results = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasTranscription"))
			#transcriptions = results.map {|m| m[:o].to_s}
			return transcriptions
		end
		def canonical_transcription
			# TODO this check against an empty array should
			# occur everywhere the filter is used
			# maybe we need a helper function that does this once
			unless self.results.count == 0 
				transcription = self.value("http://scta.info/property/hasCanonicalTranscription")
				return transcription
			end
		end
	end
end

		